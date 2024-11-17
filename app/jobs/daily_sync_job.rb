class DailySyncJob < ApplicationJob
  def perform
    User.all.each do |user|
      Import::FetchWithingsJob.perform_later(user.id) if user.withings_refresh_token?
      Import::ScanLoseitEmailJob.perform_later(user.id) # if user.loseit_email?
    end
  end
end
