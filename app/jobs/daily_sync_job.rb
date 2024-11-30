class DailySyncJob < ApplicationJob
  def perform
    # TODO: These should probably perform_later
    User.all.each do |user|
      Import::FetchWithingsJob.perform_now(user.id) if user.withings_refresh_token?
    end

    Import::ScanLoseitEmailsJob.perform_now
  end
end
