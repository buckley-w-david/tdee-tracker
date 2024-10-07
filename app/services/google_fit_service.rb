require "google/apis/fitness_v1"
require "google/api_client/client_secrets"

class GoogleFitService
  class << self
    def steps_by_date(user, start_date, end_date)
      user_credentials = Signet::OAuth2::Client.new
      user_credentials.update!(JSON.parse(user.google_fit_token))

      fitness = Google::Apis::FitnessV1::FitnessService.new
      fitness.authorization = user_credentials

      # sessions = fitness.list_user_sessions("me", start_time: stats_start.rfc3339)

      steps = fitness.aggregate_dataset("me", Google::Apis::FitnessV1::AggregateRequest.new(
        aggregate_by: [
          Google::Apis::FitnessV1::AggregateBy.new(data_type_name: "com.google.step_count.delta", data_source_id: "derived:com.google.step_count.delta:com.google.android.gms:estimated_steps")
        ],
        bucket_by_time: Google::Apis::FitnessV1::BucketByTime.new(
          duration_millis: 86400000
        ),
        start_time_millis: start_date.to_time.to_i * 1000,
        end_time_millis: end_date.to_time.to_i * 1000
      ))

      # TODO: Find a better way to handle token expiration
      user.update!(google_fit_token: user_credentials.to_json)

      steps.bucket.each_with_object({}) do |bucket, hash|
        hash[Time.at(bucket.start_time_millis / 1000).to_date] = bucket.dataset.first.point.first.value.first.int_val
      end
    end
  end
end
