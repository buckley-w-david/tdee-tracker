module Import
  class LoseitStatsJob < ApplicationJob
    def perform(user_id, blob_id, date_format)
      user = User.find(user_id)
      blob = ActiveStorage::Blob.find(blob_id)
      file = blob.download

      CSV.foreach(file, headers: true) do |row|
        next if row["Weight"].blank? && row["Kilocalories"].blank?

        day = user.days.find_or_initialize_by(date: Date.strptime(row["Date"], date_format))

        unless row["Weight"].blank?
          day.weight = row["Weight"].to_f
        end

        unless row["Kilocalories"].blank?
          day.kilocalories = row["Kilocalories"].to_i
        end

        day.save
      end
    end
  end
end
