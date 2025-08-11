require "net/http"
require "uri"
require "json"

class OauthController < ApplicationController
  def callback
    code = params[:code]
    if code.blank?
      return redirect_to photos_path, alert: "認証コードが見つかりませんでした"
    end

    uri = URI.parse(ENV.fetch("OAUTH_TOKEN_URL"))
    res = Net::HTTP.post_form(uri, {
      code: code,
      client_id: ENV.fetch("OAUTH_CLIENT_ID"),
      client_secret: ENV.fetch("OAUTH_CLIENT_SECRET"),
      redirect_uri: ENV.fetch("OAUTH_REDIRECT_URI"),
      grant_type: "authorization_code"
    })

    body = JSON.parse(res.body) rescue {}

    if res.is_a?(Net::HTTPSuccess) && body["access_token"].present?
      session[:tweet_access_token] = body["access_token"]
      redirect_to photos_path, notice: "Twitterとの連携が完了しました"
    else
      msg = body["error_description"] || "Twitterとの連携に失敗しました"
      redirect_to photos_path, alert: msg
    end
  end
end
