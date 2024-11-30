class User < ApplicationRecord
  has_secure_password

  has_many :days
  has_one :goal

  has_many :meals, through: :days
  has_many :food_entries, through: :meals
  has_many :foods, through: :food_entries

  serialize :google_fit_token, coder: JSON

  validates_uniqueness_of :username

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
