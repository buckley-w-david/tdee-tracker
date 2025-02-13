module Import
  class LoseitStatsJob < ApplicationJob
    WEIGHT = [ "Weight" ]
    KILOCALORIES = [ "Kilocalories", "Food Calories", "Calories", "Food cals" ]

    def perform(user_id, blob_id, date_format)
      user = User.find(user_id)
      blob = ActiveStorage::Blob.find(blob_id)
      file = blob.download

      CSV.foreach(file, headers: true) do |row|
        weight_key = (row.keys & WEIGHT).first
        kilocalories_key = (row.keys & KILOCALORIES).first
        next if weight_key.nil? && kilocalories_key.nil?

        day = user.days.find_or_initialize_by(date: Date.strptime(row["Date"], date_format))

        day.weight = row[weight_key].to_f unless row[weight_key].blank?
        day.kilocalories = row[kilocalories_key].to_f unless row[kilocalories_key].blank?

        day.save
      end
    end
  end
end
