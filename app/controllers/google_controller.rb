require "google/api_client/client_secrets"

class GoogleController < ApplicationController
  def connect
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

  def register
    client_secrets = Google::APIClient::ClientSecrets.new(JSON.load(ENV["GOOGLE_FIT_CLIENT_SECRET_JSON"]))
    user_credentials = client_secrets.to_authorization

    user_credentials.update!(params.permit(:code))
    user_credentials.fetch_access_token!

    current_user.update!(google_fit_token: user_credentials.to_json)

    redirect_to root_path, notice: "Google Fit registered successfully"
  end
end
