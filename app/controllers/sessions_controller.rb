class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      #session[:user_id] = user　と言う事
      log_in user
      #user_url(user)　という名前付きルートになる
      redirect_to user
    else
      flash.now[:danger] = t('.login_error')
      render 'new'
    end
  end

  def destroy
  end
end