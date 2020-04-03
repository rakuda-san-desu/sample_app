class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if user.activated?
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or @user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
      # #session[:user_id] = @user　と言う事
      # log_in @user
      # #params[:session][:remember_me]が1の時@userを記憶　そうでなければuserを忘れる
      # params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      # #SessionsHelperで定義したredirect_back_orメソッドを呼び出してリダイレクト先を定義
      # # 本文ではデフォルト値が「user」になってるけど「@user」が正解
      # redirect_back_or @user
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