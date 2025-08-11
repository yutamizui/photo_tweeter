require "net/http"
require "uri"
require "json"

class OauthController < ApplicationController
  def callback
    code = params[:code]
    if code.blank?
      return redirect_to photos_path, alert: "認証コードが見つかりませんでした"
    end

    res = UnifaApi.oauth(code)
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
