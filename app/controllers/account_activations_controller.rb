class AccountActivationsController < ApplicationController

  def edit
    # userに代入　→　Userテーブルから　URLから取得したemailの値を持つ　userデータを取得して
    user = User.find_by(email: params[:email])
    # userが存在する　かつ　userがactivatedではない　かつ　有効化ダイジェストとparams[:id](有効化トークン)が一致した場合
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      # userのactivatedの値をtrueに
      user.update_attribute(:activated,    true)
      # useractivated_atの値を現在時刻に
      user.update_attribute(:activated_at, Time.zone.now)
      # userでログイン（Sessionsヘルパーのlog_inメソッドを呼び出し）
      log_in user
      # flashメッセージを表示
      flash[:success] = t(".account_activation_successful")
      # userページにリダイレクト
      redirect_to user
    #if文の評価がfalseの場合
    else
      # flashメッセージを表示
      flash[:danger] = t(".invalid_activation_link")
      # ルートURLにリダイレクト
      redirect_to root_url
    end
  end
end