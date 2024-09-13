class User < ApplicationRecord
  has_secure_password

  has_many :days
  has_one :goal

  # I am not sure I like sticking this here...
  def withings_client
    if Time.current >= withings_expires_at
      tokens = Withings::Client.refresh_tokens(withings_refresh_token)

      update!(
        withings_access_token: tokens[:access_token],
        withings_refresh_token: tokens[:refresh_token],
        withings_expires_at: tokens[:expires_at],
      )
    end

    Withings::Client.new(withings_access_token)
  end
end
