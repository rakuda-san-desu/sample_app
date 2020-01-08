class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      #session[:user_id] = user　と言う事
      log_in user
      #ログインしてユーザーを保持
      remember user
      #user_url(user)　という名前付きルートになる
      redirect_to user
    else
      flash.now[:danger] = t('.login_error')
      render 'new'
    end
  end

  def destroy
    #logged_in?がtrueの場合に限ってlog_out（sessions_helperのlog_outメソッド）
    log_out if logged_in?
    #ルートURLにリダイレクト
    redirect_to root_url
  end
end