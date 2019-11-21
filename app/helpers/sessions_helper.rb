module SessionsHelper
  
  # 渡されたユーザーでcookieを使ってログインする
  def log_in(user)
    session[:user_id] = user.id
  end
  
end
