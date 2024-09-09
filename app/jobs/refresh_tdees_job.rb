class RefreshTdeesJob < ApplicationJob
  def perform(user_id, date)
    user = User.find(user_id)

    invalidated = user.tdees
      .where("CAST(julianday(date) AS INT) BETWEEN CAST(julianday(:date) AS INT) AND CAST(julianday(:date) AS INT)+span", date:)

    invalidated.each do |tdee|
      tdee.update!(
        tdee: TdeeService.calculate(user, tdee.date, 49)
      )
    end
  end
end
