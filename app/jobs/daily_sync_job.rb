class DailySyncJob < ApplicationJob
  def perform
    User.all.each do |user|
      Import::FetchWithingsJob.perform_later(user.id) if user.withings_refresh_token?
    end

    Import::ScanLoseitEmailsJob.perform_later
  end
end
