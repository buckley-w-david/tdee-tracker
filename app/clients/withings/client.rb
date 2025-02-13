class Withings::Client
  REDIRECT_URI = "http://tdee.fizzbuzz.ca/integrations/withings/register"

  def initialize(access_token)
    @client = Faraday.new("https://wbsapi.withings.net") do |conn|
      conn.request :authorization, "Bearer", access_token
      conn.response :json
    end
  end

  # https://developer.withings.com/api-reference#tag/measure/operation/measure-getmeas
  def get_measurement(**args)
    response = @client.get("/measure") do |req|
      req.params = {
        action: "getmeas",
        **args
      }
    end

    self.class.process_status!(response.body["status"])

    response.body["body"]
  end

  class << self
    # https://developer.withings.com/api-reference#tag/oauth2
    def generate_tokens(code)
      response = Faraday.post("https://wbsapi.withings.net/v2/oauth2") do |req|
        req.headers["Content-Type"] = "application/x-www-form-urlencoded"
        req.body = URI.encode_www_form({
          action: "requesttoken",
          client_id:,
          client_secret:,
          grant_type: "authorization_code",
          code:,
          redirect_uri: REDIRECT_URI
        })
      end

      body = JSON.parse(response.body)
      process_status!(body["status"])

      {
        user_id: body.dig("body", "userid"),
        access_token: body.dig("body", "access_token"),
        refresh_token: body.dig("body", "refresh_token"),
        expires_at: Time.current + body.dig("body", "expires_in")
      }
    end

    def refresh_tokens(refresh_token)
      response = Faraday.post("https://wbsapi.withings.net/v2/oauth2") do |req|
        req.headers["Content-Type"] = "application/x-www-form-urlencoded"
        req.body = URI.encode_www_form({
          action: "requesttoken",
          client_id:,
          client_secret:,
          grant_type: "refresh_token",
          refresh_token:
        })
      end

      body = JSON.parse(response.body)
      process_status!(body["status"])

      {
        user_id: body.dig("body", "userid"),
        access_token: body.dig("body", "access_token"),
        refresh_token: body.dig("body", "refresh_token"),
        expires_at: Time.current + body.dig("body", "expires_in")
      }
    end

    # https://developer.withings.com/api-reference/#tag/oauth2/operation/oauth2-revoke
    def revoke_tokens(user_id)
      params = {
        "action" => "getnonce",
        "client_id" => client_id,
        "timestamp" => Time.current.to_i
      }
      params["signature"] = signature(**params)
      response = Faraday.post("https://wbsapi.withings.net/v2/signature") do |req|
        req.headers["Content-Type"] = "application/x-www-form-urlencoded"
        req.body = URI.encode_www_form(params)
      end

      body = JSON.parse(response.body)
      process_status!(body["status"])

      nonce = body.dig("body", "nonce")
      params = {
        "action" => "revoke",
        "client_id" => client_id,
        "nonce" => nonce,
        "userid" => user_id
      }
      params["signature"] = signature(action: "revoke", client_id: client_id, nonce: nonce)

      response = Faraday.post("https://wbsapi.withings.net/v2/oauth2") do |req|
        req.headers["Content-Type"] = "application/x-www-form-urlencoded"
        req.body = URI.encode_www_form(params)
      end

      body = JSON.parse(response.body)
      process_status!(body["status"])

      true
    end

    class WithingsError < StandardError
    end

    # https://developer.withings.com/api-reference/#tag/response_status
    def process_status!(code)
      case code
      when 0 then :success
      when 100..102 then raise WithingsError, "Authentication failed"
      when 200 then raise WithingsError, "Authentication failed"
      when 201..213 then raise WithingsError, "Invalid params"
      when 214 then raise WithingsError, "Unauthorized"
      when 215 then raise WithingsError, "An error occurred"
      when 216..218 then raise WithingsError, "Invalid params"
      when 219 then raise WithingsError, "An error occurred"
      when 220...221 then raise WithingsError, "Invalid params"
      when 222 then raise WithingsError, "An error occurred"
      when 223 then raise WithingsError, "Invalid params"
      when 224 then raise WithingsError, "An error occurred"
      when 225 then raise WithingsError, "Invalid params"
      when 226 then raise WithingsError, "An error occurred"
      when 227..230 then raise WithingsError, "Invalid params"
      when 231..233 then raise WithingsError, "An error occurred"
      when 234..236 then raise WithingsError, "Invalid params"
      when 237 then raise WithingsError, "An error occurred"
      when 238 then raise WithingsError, "Invalid params"
      when 240..252 then raise WithingsError, "Invalid params"
      when 253 then raise WithingsError, "An error occurred"
      when 254 then raise WithingsError, "Invalid params"
      when 255..259 then raise WithingsError, "An error occurred"
      when 260..267 then raise WithingsError, "Invalid params"
      when 268..270 then raise WithingsError, "An error occurred"
      when 271..272 then raise WithingsError, "Invalid params"
      when 273..274 then raise WithingsError, "An error occurred"
      when 275..276 then raise WithingsError, "Invalid params"
      when 277 then raise WithingsError, "Unauthorized"
      when 278..282 then raise WithingsError, "An error occurred"
      when 283..288 then raise WithingsError, "Invalid params"
      when 289 then raise WithingsError, "An error occurred"
      when 290 then raise WithingsError, "Invalid params"
      when 291..292 then raise WithingsError, "An error occurred"
      when 293..295 then raise WithingsError, "Invalid params"
      when 296 then raise WithingsError, "An error occurred"
      when 297 then raise WithingsError, "Invalid params"
      when 298 then raise WithingsError, "An error occurred"
      when 300..304 then raise WithingsError, "Invalid params"
      when 305..320 then raise WithingsError, "An error occurred"
      when 321 then raise WithingsError, "Invalid params"
      when 322 then raise WithingsError, "An error occurred"
      when 323..353 then raise WithingsError, "Invalid params"
      when 370..375 then raise WithingsError, "An error occurred"
      when 380..382 then raise WithingsError, "Invalid params"
      when 383 then raise WithingsError, "An error occurred"
      when 391 then raise WithingsError, "An error occurred"
      when 400 then raise WithingsError, "Invalid params"
      when 401 then raise WithingsError, "Authentication failed"
      when 402 then raise WithingsError, "An error occurred"
      when 501..511 then raise WithingsError, "Invalid params"
      when 516..521 then raise WithingsError, "An error occurred"
      when 522 then raise WithingsError, "Timeout"
      when 523 then raise WithingsError, "Invalid params"
      when 524 then raise WithingsError, "Bad state"
      when 525..531 then raise WithingsError, "An error occurred"
      when 532 then raise WithingsError, "Invalid params"
      when 533 then raise WithingsError, "An error occurred"
      when 601 then raise WithingsError, "Too many request"
      when 602 then raise WithingsError, "An error occurred"
      when 700 then raise WithingsError, "An error occurred"
      when 1051..1054 then raise WithingsError, "An error occurred"
      when 2551..2552 then raise WithingsError, "An error occurred"
      when 2553 then raise WithingsError, "Unauthorized"
      when 2554 then raise WithingsError, "Not implemented"
      when 2555 then raise WithingsError, "Unauthorized"
      when 2556..2559 then raise WithingsError, "An error occurred"
      when 3000..3016 then raise WithingsError, "An error occurred"
      when 3017..3019 then raise WithingsError, "Invalid params"
      when 3020..3024 then raise WithingsError, "An error occurred"
      when 5000..5006 then raise WithingsError, "An error occurred"
      when 6000 then raise WithingsError, "An error occurred"
      when 6010..6011 then raise WithingsError, "An error occurred"
      when 9000 then raise WithingsError, "An error occurred"
      when 10000 then raise WithingsError, "An error occurred"
      end
    end

    def signature(**args)
      keys = args.keys.sort
      s = keys.map { |k| args[k] }.join(",")
      hmac = OpenSSL::HMAC.hexdigest("SHA256", client_secret, s)
    end

    private

    def client_secret
      ENV["WITHINGS_CLIENT_SECRET"]
    end

    def client_id
      ENV["WITHINGS_CLIENT_ID"]
    end
  end
end
