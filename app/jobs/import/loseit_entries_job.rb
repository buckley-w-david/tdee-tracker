require "csv"

module Import
  class LoseitEntriesJob < ApplicationJob
    def perform(user_id, blob_id)
      user = User.find(user_id)
      blob = ActiveStorage::Blob.find(blob_id)

      importer = Import::LoseitEntriesService.new(user)
      file = blob.download

      CSV.parse(file, headers: true).each do |row|
        next if row["Deleted"] == "1"

        importer.import(row)
      rescue
        # TODO: Find why this is failing sometimes
        Rails.logger.error "Error importing row: #{row}"
      end

      blob.purge
    end
  end
end
