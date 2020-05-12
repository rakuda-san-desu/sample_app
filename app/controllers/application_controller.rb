class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  #Sessionヘルパーモジュールの読み込み
  include SessionsHelper
  
  private
  
    # ログイン済みユーザーかどうか確認
    def logged_in_user
      # logged_in?がfalseの場合
      unless logged_in?
        # SessionsHelperメソッド　store_locationの呼び出し
        store_location
        # flashsでエラーメッセージを表示
        flash[:danger] = t('users.please_log_in')
        # login_urlにリダイレクト
        redirect_to login_url
      end
    end
    
end
