class RegisterWithingsJob < ApplicationJob
  def perform(user_id, code, state)
    user = User.find(user_id)

    tokens = Withings::Client.generate_tokens(code, state)

    user.update!(
      withings_user_id: tokens[:user_id],
      withings_refresh_token: tokens[:refresh_token],
      withings_access_token: tokens[:access_token],
      withings_expires_at: tokens[:expires_at],
    )
  end
end
