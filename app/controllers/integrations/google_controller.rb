require "google/api_client/client_secrets"

class IntegrationsController < ApplicationController
  def show
    # FIXME: Define domain in config
    @withings_url = "https://account.withings.com/oauth2_user/authorize2?response_type=code"\
      "&client_id=#{ENV['WITHINGS_CLIENT_ID']}"\
      "&scope=user.info,user.metrics,user.activity"\
      "&redirect_uri=http://tdee.fizzbuzz.ca"\
      "&state=#{Digest::MD5.hexdigest(@current_user.username)}"
  end

  def withings_register
    state = params[:state]
    digest = Digest::MD5.hexdigest(@current_user.username)

    return redirect_to(root_path, flash: { danger: "Withings registration failed" }) unless ActiveSupport::SecurityUtils.secure_compare(state, digest)

    code = params[:code]

    tokens = Withings::Client.generate_tokens(code, state)

    current_user.update!(
      withings_user_id: tokens[:user_id],
      withings_refresh_token: tokens[:refresh_token],
      withings_access_token: tokens[:access_token],
      withings_expires_at: tokens[:expires_at],
    )

    redirect_to(root_path, flash: { success: "Connceted to Withings API" })
  end

  def google_connect
    client_secrets = Google::APIClient::ClientSecrets.new(JSON.load(ENV["GOOGLE_FIT_CLIENT_SECRET_JSON"]))
    user_credentials = client_secrets.to_authorization
    user_credentials.update!(
      scope: "https://www.googleapis.com/auth/fitness.activity.read",
    )
    user_credentials .update!(
      additional_parameters: { "access_type" => "offline" }
    )

    redirect_to user_credentials.authorization_uri.to_s, status: 303, allow_other_host: true
  end

  def google_register
    client_secrets = Google::APIClient::ClientSecrets.new(JSON.load(ENV["GOOGLE_FIT_CLIENT_SECRET_JSON"]))
    user_credentials = client_secrets.to_authorization

    user_credentials.update!(params.permit(:code))
    user_credentials.fetch_access_token!

    current_user.update!(google_fit_token: user_credentials.to_json)

    redirect_to root_path, notice: "Google Fit registered successfully"
  end
end
