# frozen_string_literal: true
# typed: true

class CalendarController < ApplicationController
  def index
    start_date = params[:start_date]&.to_date || Time.current
    previous_month = start_date.advance(months: -1)
    next_month = start_date.advance(months: 1)

    days = @current_user
      .days
      .where(date: previous_month.all_month.first..next_month.all_month.last)

    @days = days.index_by(&:date)

    # More than just the start_date month is used in the calculate of the EMA to give it enough data to be accurate at the start of the month
    @weight, @ema = Stats.weight_ema(days, period: 14)

    # The excess data is then removed for display
    @weight.filter! { |date, _| date.month == start_date.month }
    @ema.filter! { |date, _| date.month == start_date.month }
  end
end
