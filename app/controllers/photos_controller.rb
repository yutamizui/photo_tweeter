class PhotosController < ApplicationController
  before_action :require_login

  def index
    @photos = current_user.photos.order(created_at: :desc)
  end

  def new
    @photo = Photo.new
  end

  def create
    @photo = current_user.photos.build(photo_params)
    if @photo.save
      redirect_to photos_path
    else
    render :new
    end
  end

  def destroy
    photo = current_user.photos.find(params[:id])
    photo.destroy
    redirect_to photos_path, notice: "写真を削除しました"
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
