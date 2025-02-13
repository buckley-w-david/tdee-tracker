module Integrations
  class WithingsController < ApplicationController
    def authorize
      # FIXME: Define domain in config
      withings_url = "https://account.withings.com/oauth2_user/authorize2?response_type=code"\
        "&client_id=#{ENV['WITHINGS_CLIENT_ID']}"\
        "&scope=user.info,user.metrics,user.activity"\
        "&redirect_uri=#{Withings::Client::REDIRECT_URI}"\
        "&state=#{Digest::MD5.hexdigest(@current_user.username)}"

      redirect_to withings_url, allow_other_host: true
    end

    def register
      state = params[:state]
      digest = Digest::MD5.hexdigest(@current_user.username)

      return redirect_to(root_path, flash: { danger: "Withings registration failed" }) unless ActiveSupport::SecurityUtils.secure_compare(state, digest)

      tokens = Withings::Client.generate_tokens(params[:code])

      current_user.update!(
        withings_user_id: tokens[:user_id],
        withings_refresh_token: tokens[:refresh_token],
        withings_access_token: tokens[:access_token],
        withings_expires_at: tokens[:expires_at],
      )

      redirect_to(root_path, flash: { success: "Connceted to Withings API" })
    end

    def revoke
      Withings::Client.revoke(@current_user.withings_user_id.to_i)

      # TODO: Should we also null out withings_last_updated_at?
      @current_user.update!(withings_access_token: nil, withings_refresh_token: nil, withings_expires_at: nil, withings_user_id: nil)

      redirect_to(root_path, flash: { success: "Disconnected from Withings" })
    end
  end
end
