require "csv"

class DaysController < ApplicationController
  before_action :set_day, only: [ :edit, :update ]

  def index
    @date = Time.current.to_date
    @day = Day.find_or_initialize_by(
      date: @date
    )

    @tdee_data = @current_user
      .days
      .order(date: :asc)
      .pluck(:date, :total_daily_expended_energy)

    @kilocalories = @current_user
      .days
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

    # TODO: Revamp TDEE calculation to use EMA of weights intead of linear fit
    @ema = TechnicalAnalysis::Ema.calculate(@weight.map { |d, t| { date_time: d, value: t } }).map do |ema|
      [ ema.date_time, ema.ema ]
    end.to_h

    if @current_user.goal
      tdee = @day.total_daily_expended_energy
      delta_w = @current_user.goal.change_per_week
      change_per_day = (delta_w / 7) * 3500 # In kilocalories

      @target_kilocalories = if tdee
        (tdee + change_per_day).round(0)
      end
    end
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
