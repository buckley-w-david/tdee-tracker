# frozen_string_literal: true
# typed: true

class CalendarController < ApplicationController
  def index
    start_date = params[:start_date]&.to_date || Time.current
    previous_month = start_date.advance(months: -1)
    next_month = start_date.advance(months: 1)

    @days = @current_user
      .days
      .where(date: previous_month.all_month.first..next_month.all_month.last)
      .index_by(&:date)
  end
end
