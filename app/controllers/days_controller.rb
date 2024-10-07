require "csv"


class DaysController < ApplicationController
  before_action :set_day, only: [ :edit, :update ]

  def index
    @date = Time.current.to_date
    @day = Day.find_or_initialize_by(
      date: @date
    )

    stats_start = @date - 45.days

    # FIXME: This is duplicated in the stats controller
    #        DRY it up
    @tdee_data = @current_user
      .days.where(date: stats_start..@date)
      .order(date: :asc)
      .pluck(:date, :total_daily_expended_energy)


    @kilocalories = @current_user
      .days.where(date: stats_start..@date)
      .order(date: :asc)
      .pluck(:date, :kilocalories)

    @weight = @current_user
      .days
      # TODO: Think about what the implications of a missed weigh in are
      #       The EMA implementation cannot handle `nil` data, and its "period" is measured in number of data points, not days.
      #       This means missed days will result in a measure of n+m days (n = period length, m = missed days)
      #       This has implications on using it to calculate TDEE since it will be difficult to reason about number of kcals over that same period
      #       We could replace missed days with a straight line approximation between the most recent past measure, and the most recent future measure
      .where.not(weight: nil)
      .order(date: :asc)
      .pluck(:date, :weight)

    @ema = TechnicalAnalysis::Ema.calculate(@weight.map { |d, t| { date_time: d, value: t } }, period: 14).map do |ema|
      [ ema.date_time, ema.ema ]
    end.to_h

    if current_user.google_fit_token.present?
      @steps_by_day = GoogleFitService.steps_by_date(current_user, stats_start, @date.end_of_day)
    end

    # Experimental TDEE calculation using EMA of weights
    # It takes a _lot_ of data before this starts giving results
    kcal_avg = Day.connection.execute(<<-SQL)
      SELECT date, (
        SELECT avg(kilocalories)
        FROM days d2
          WHERE d2.date BETWEEN date(d.date, '-22 days') AND date(d.date, '-1 day')
      ) avg
      FROM days d
    SQL
      .map { |row| [ row["date"].to_date, row["avg"] ] }.to_h

    x = []
    y = []

    @ema.each do |date, ema|
      y << ema
      x << date
    end

    x.reverse!
    y.reverse!

    @tdee_alt = []
    x.zip(y).each_cons(21) do |xy|
      xx, yy = xy.transpose

      linefit = LineFit.new
      linefit.setData(xx.map(&:jd), yy)
      _, slope = linefit.coefficients

      d = xx.last
      tdee = (kcal_avg[d] - 3500*slope).to_f

      @tdee_alt << [ d, tdee ]
    end

    @ema.filter! { |date, _| date >= stats_start }
    @weight.filter! { |date, _| date >= stats_start }
    @tdee_alt.filter! { |date, _| date >= stats_start }
  end

  def new
    @day = Day.new(date: params[:date])
  end

  def create
    @day = @current_user.days.build(**day_params)

    if @day.save
      respond_to do |format|
        format.html { redirect_to(root_path, flash: { success: "day was successfully created." }) }
        format.turbo_stream do
          flash.now[:success] = "day was successfully created."
          render turbo_stream: turbo_stream.update("flash-container", partial: "layouts/flash")
        end
      end
    else
      flash.now[:danger] = @day.errors
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @day.update(day_params)
      respond_to do |format|
        format.html { redirect_to(root_path, flash: { success: "day was successfully updated." }) }
        format.turbo_stream do
          flash.now[:success] ="day was successfully updated."
          render turbo_stream: turbo_stream.update("flash-container", partial: "layouts/flash")
        end
      end
    else
      flash.now[:danger] = @day.errors
      render :new, status: :unprocessable_entity
    end
  end

  def by_date
    @day = @current_user.days.find_by(date: params[:date])

    if @day.nil?
      redirect_to(new_day_path(date: params[:date]))
    else
      redirect_to(edit_day_path(@day))
    end
  end

  def import_values
    file = File.open(params[:file])
    format = params[:date_format] || "%m/%d/%Y"

    CSV.foreach(file, headers: true) do |row|
      next if row["Weight"].blank? && row["Kilocalories"].blank?

      day = @current_user.days.find_or_initialize_by(date: Date.strptime(row["Date"], format))

      unless row["Weight"].blank?
        day.weight = row["Weight"].to_f
      end

      unless row["Kilocalories"].blank?
        day.kilocalories = row["Kilocalories"].to_i
      end

      day.save
    end
  end

  private

  def set_day
    @day = @current_user.days.find(params[:id])
  end

  def day_params
    params.require(:day).permit(:kilocalories, :weight, :date)
  end
end
