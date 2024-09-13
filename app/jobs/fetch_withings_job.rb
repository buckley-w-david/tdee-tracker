class FetchWithingsJob < ApplicationJob
  def perform
    User.where.not(withings_refresh_token: nil).each do |user|
      client = user.withings_client

      options = {
        "meastype" => Withings::MeasureType::WEIGHT,
        "category" => Withings::MeasureCategory::REAL
      }

      if user.withings_last_updated_at
        options["lastupdate"] = user.withings_last_updated_at.to_i
      end

      user.update!(
        withings_last_updated_at: Time.current
      )

      response = client.get_measurement(**options)
      response["measuregrps"].each do |group|
        date = Time.at(group["created"]).to_date
        group["measures"].each do |measure|
          next unless measure["type"] == Withings::MeasureType::WEIGHT

          kg = measure["value"] * 10**measure["unit"]
          # FIXME: Harcoded number bad
          lbs = 2.20462 * kg

          day = user.days.find_or_initialize_by(date:)
          day.weight = lbs.round(2)

          day.save! if day.weight_changed?
        end
      end
    end
  end
end
