class RefreshTdeesJob < ApplicationJob
  def perform(day_id)
    day = Day.find(day_id)
    date = day.date
    user = day.user

    invalidated = user.days
      # TODO: Don't hardcode span
      .where("CAST(julianday(date) AS INT) BETWEEN CAST(julianday(:date) AS INT) AND CAST(julianday(:date) AS INT)+49", date:)

    invalidated.each do |day|
      day.total_daily_expended_energy = TdeeService.calculate(day)
      day.save! if day.changed?
    end
  end
end
