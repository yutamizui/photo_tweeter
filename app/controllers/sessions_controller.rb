class SessionsController < ApplicationController
  def new
  end

  def create
    @errors   = []
    @user_id  = params[:user_id].to_s
    password  = params[:password].to_s

    @errors << "ユーザーIDを入力してください" if @user_id.blank?
    @errors << "パスワードを入力してください" if password.blank?

    if @errors.any?
      return render :new, status: :ok
    end

    user = User.find_by(user_id: @user_id)
    if user&.authenticate(password)
      session[:user_id] = user.id
      redirect_to photos_path
    else
      @errors << "ユーザーIDまたはパスワードが正しくありません"
      render :new, status: :ok
    end
  end

  def destroy
    reset_session
    redirect_to login_path
  end
end

