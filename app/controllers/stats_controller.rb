class StatsController < ApplicationController
  def index
    @date = Time.current.to_date
    if params[:last]
      stats_start = @date - params[:last].to_i.days
    end

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

    # TODO: Revamp TDEE calculation to use EMA of weights intead of linear fit
    @ema = TechnicalAnalysis::Ema.calculate(@weight.map { |d, t| { date_time: d, value: t } }, period: 14).map do |ema|
      [ ema.date_time, ema.ema ]
    end.to_h

    @ema.filter! { |date, _| stats_start.nil? || date >= stats_start }
    @weight.filter! { |date, _| stats_start.nil? || date >= stats_start }

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("stats", partial: "days/stats")
      end
    end
  end
end
