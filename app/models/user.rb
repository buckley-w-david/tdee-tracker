class User < ApplicationRecord
  has_secure_password

  has_many :entries
  has_many :total_daily_expended_energies

  alias_method :tdees, :total_daily_expended_energies

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

    client = Withings::Client.new(withings_access_token)
  end
end
