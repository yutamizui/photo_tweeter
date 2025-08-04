class SessionsController < ApplicationController
  def new
  end

  def create
    if params[:user_id].blank? || params[:password].blank?
      flash.now[:alert] = "ユーザーIDとパスワードを入力してください"
      return render :new
    end

    user = User.find_by(user_id: params[:user_id])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to photos_path
    else
      flash.now[:alert] = "ユーザーIDまたはパスワードが正しくありません"
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to login_path
  end
end
