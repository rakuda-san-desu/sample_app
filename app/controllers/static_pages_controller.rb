class StaticPagesController < ApplicationController
  
  def home
    # @micropostに　ユーザーがログインしていればログイン中のユーザーに紐付いた新しいMicropostオブジェクトを返す
    @micropost = current_user.microposts.build if logged_in?
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
  
end
