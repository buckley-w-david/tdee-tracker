# frozen_string_literal: true

require "net/imap"
require "csv"

module Import
  class ScanLoseitEmailsJob < ApplicationJob
    def perform
      # TODO: These need to pull from a user specific data source
      imap = Net::IMAP.new(ENV["EMAIL_HOST"], port: 993, ssl: true)
      imap.login(ENV["EMAIL_USERNAME"], ENV["EMAIL_PASSWORD"])

      # TODO: Probably shouldn't hardcode this
      imap.select("Automation/loseit")

      imap.uid_search([ "NOT", "SEEN" ]).each do |uid|
        parts = imap.uid_fetch(uid, [ "BODY[1]", "BODY[2]" ]).first

        csv_text = parts.attr["BODY[2]"]

        # This is very dependent on the structure of the email
        # If LoseIt changes the email format, this will break
        # I don't expect that to be a problem, as the email reports (and everything outside of the app)
        # feels like it hasn't been updated in years
        message_text = parts.attr["BODY[1]"]
        document = Nokogiri::HTML.parse(message_text)

        eoi = document.xpath('//*[contains(text(), "Food calories consumed")]').first
        kilocalories = eoi.next_element.text.gsub(/[^0-9]/, "").to_i

        eoi = document.xpath('//*[contains(text(), "Today\'s Weight")]').first
        weight = eoi.next_element.text.to_f

        # It is hilarious that this works
        header = document.xpath("//h3").first
        date = Date.parse(header.text)
        username = header.next_element.text.match(/for (.*)/)

        imap.uid_store(uid, "+FLAGS", [ :Seen ])

        loseit_username = username&.captures&.first

        user = User.find_by(username: loseit_username)

        if user.nil?
          Rails.logger.warn "No user found for LoseIt username: #{loseit_username}"
          next
        end

        importer = Import::LoseitEntriesService.new(user)

        CSV.parse(csv_text, headers: true).each do |row|
          next if row["Deleted"] == "1"

          importer.import(row)
        rescue
          Rails.logger.error "Error importing row: #{row}"
        end

        day = user.days.find_or_initialize_by(date: date)
        day.kilocalories = kilocalories

        # Don't love having to check this, but such is life. I don't want to overwrite the value synced from Withings
        day.weight = weight unless user.withings_refresh_token?

        day.save!
      rescue => e
        Rails.logger.error "Error processing email: #{uid} - #{e}"
      end
    ensure
      imap.logout
      imap.disconnect
    end
  end
end
