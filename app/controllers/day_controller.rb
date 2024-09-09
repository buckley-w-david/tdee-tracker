require 'technical-analysis'

class DayController < ApplicationController
  before_action :fetch_stats

  def index
    today = Time.current.to_date
    @date = today

    @entry = Entry.find_or_initialize_by(
      date: today
    )

    render 'show'
  end

  def show
    @date = params[:id].to_date

    @entry = Entry.find_or_initialize_by(
      date: @date
    )

    @tdee = @current_user
      .tdees
      .where("date <= ?", @date)
      .order(date: :desc).first
  end

  private

  def fetch_stats
    @tdee_data = @current_user
      .tdees
      .order(date: :asc)
      .pluck(:date, :tdee)

    @kilocalories = @current_user
      .entries
      .order(date: :asc)
      .pluck(:date, :kilocalories)


    @weight = @current_user
      .entries
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
      [ema.date_time, ema.ema]
    end.to_h
  end
end
