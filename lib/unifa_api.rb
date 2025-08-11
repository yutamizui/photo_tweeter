# lib/unifa_api.rb
require "net/http"
require "uri"
require "json"

class UnifaApi
  class << self
    def oauth(code)
      uri = URI.parse(ENV.fetch("OAUTH_TOKEN_URL"))

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == "https")

      req = Net::HTTP::Post.new(uri.request_uri)
      req.set_form_data(
        code: code,
        client_id: ENV.fetch("OAUTH_CLIENT_ID"),
        client_secret: ENV.fetch("OAUTH_CLIENT_SECRET"),
        redirect_uri: ENV.fetch("OAUTH_REDIRECT_URI"),
        grant_type: "authorization_code"
      )

      http.request(req)
    end
  end

  attr_reader :access_token

  def initialize(access_token)
    if access_token.blank?
      raise ArgumentError, "access_tokenがありません。外部アプリと連携してください。"
    end

    @access_token = access_token
    @uri = URI.parse(ENV.fetch("TWEET_API_URL"))
  end

  def tweet(payload)
    http = Net::HTTP.new(@uri.host, @uri.port)
    http.use_ssl = (@uri.scheme == "https")
    req = Net::HTTP::Post.new(@uri.request_uri, {
      "Authorization" => "Bearer #{@access_token}",
      "Content-Type"  => "application/json"
    })
    req.body = payload.to_json

    http.request(req)
  end
end