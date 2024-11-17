# frozen_string_literal: true

require "net/imap"
require "csv"

module Import
  class ScanLoseitEmailJob < ApplicationJob
    def perform
      imap = Net::IMAP.new(ENV["EMAIL_HOST"], port: 993, ssl: true)
      imap.login(ENV["EMAIL_USERNAME"], ENV["EMAIL_PASSWORD"])

      # TODO: Probably shouldn't hardcode this
      imap.select("Automation/loseit")

      # TODO: How to do proper user lookup?
      #       Will probably need to set up a new table and use that instead of environment variables
      user = User.first
      importer = Import::LoseitEntriesService.new(user)

      imap.uid_search([ "NOT", "SEEN" ]).each do |uid|
        parts = imap.uid_fetch(uid, [ "BODY[1]", "BODY[2]" ]).first

        csv_text = parts.attr["BODY[2]"]

        CSV.parse(csv_text, headers: true).each do |row|
          next if row["Deleted"] == "1"

          importer.import(row)
        rescue
          Rails.logger.error "Error importing row: #{row}"
        end

        # This is very dependent on the structure of the email
        # If LosseIt changes the email format, this will break
        # I don't expect that to be a problem, as the email reports (and everything outside of the app)
        # feels like it hasn't been updated in years
        message_text = parts.attr["BODY[1]"]
        document = Nokogiri::HTML.parse(message_text)
        eoi = document.xpath('//*[contains(text(), "Food calories consumed")]').first
        kilocalories = eoi.next_element.text.gsub(/[^0-9]/, "").to_i

        # It is hilarious that this works
        date = Date.parse(document.xpath("//h3").first.text)

        day = user.days.find_or_initialize_by(date: date)
        day.kilocalories = kilocalories
        day.save!

        imap.uid_store(uid, "+FLAGS", [ :Seen ])
      rescue => e
        Rails.logger.error "Error processing email: #{uid} - #{e}"
      end
    ensure
      imap.logout
      imap.disconnect
    end
  end
end
