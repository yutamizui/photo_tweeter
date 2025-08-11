require "net/http"
require "uri"
require "json"

class PhotosController < ApplicationController
  before_action :require_login

  def index
    @photos = current_user.photos.order(created_at: :desc)
  end

  def show
    photo = Photo.find(params[:id])
    redirect_to rails_blob_url(photo.image)
  end

  def new
    @photo = Photo.new
  end

  def create
    @photo = current_user.photos.build(photo_params)
    if @photo.save
      redirect_to photos_path
    else
      render :new, status: :ok
    end
  end

  # def destroy
  #   photo = current_user.photos.find(params[:id])
  #   photo.destroy
  #   redirect_to photos_path, notice: "写真を削除しました"
  # end

  def tweet
    access_token = session[:tweet_access_token]
    return redirect_to(photos_path, alert: "まずは外部アプリと連携してください") unless access_token.present?

    photo = current_user.photos.find(params[:id])
    return redirect_to(photos_path, alert: "画像が添付されていません") unless photo.image.attached?

    image_url = photo_url(photo, format: :jpg)

    uri  = URI.parse(ENV.fetch("TWEET_API_URL"))
    http = Net::HTTP.new(uri.host, uri.port)
    req  = Net::HTTP::Post.new(uri.request_uri, {
      "Authorization" => "Bearer #{access_token}",
      "Content-Type"  => "application/json"
    })
    req.body = { text: photo.title, url: image_url }.to_json

    Rails.logger.info("[TWEET] POST #{uri} body=#{req.body}")

    begin
      res = http.request(req)
      Rails.logger.info("[TWEET] status=#{res.code} body=#{res.body}")

      if res.code.to_i == 201
        redirect_to photos_path, notice: "ツイートしました"
      elsif res.code.to_i == 401
        session.delete(:tweet_access_token)
        redirect_to photos_path, alert: "認証エラーです。もう一度連携してください（401）"
      else
        redirect_to photos_path, alert: "ツイートに失敗しました（#{res.code}）"
      end
    rescue => e
      Rails.logger.error("[TWEET] error=#{e.class} #{e.message}")
      redirect_to photos_path, alert: "ツイート送信中にエラーが発生しました"
    end
  end

  private

  def photo_params
    params.require(:photo).permit(:title, :image)
  end

  def require_login
    unless current_user
      redirect_to login_path
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
