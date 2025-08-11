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

  def tweet
    access_token = session[:tweet_access_token]
    photo = current_user.photos.find(params[:id])
    return redirect_to(photos_path, alert: "画像が添付されていません") unless photo.image.attached?
    image_url = photo_url(photo, format: :jpg)

    begin
      tweet_client = UnifaApi.new(access_token)
      Rails.logger.info("34-Access_token: #{access_token}")
      res = tweet_client.tweet({ text: photo.title, url: image_url })
      Rails.logger.info("[TWEET] response=#{res.inspect}")
      if res.is_a?(Net::HTTPSuccess)
        redirect_to photos_path, notice: "ツイートしました"
      else
        raise "ツイートに失敗しました（#{res.code}）"
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
end
