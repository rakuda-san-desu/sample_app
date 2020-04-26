class PasswordResetsController < ApplicationController
  # フィルタの内容は下部private以下
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  
  def new
  end

  def create
    # @userに代入→（フォームに入力された）email(を小文字にしたやつ）を持ったuserをDBから見つけてる
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    # もし　@userが存在すれば
    if @user
      # @userのパスワード再設定の属性を設定する（create_reset_digestはapp/models/user.rbにある）
      @user.create_reset_digest
      # @userにパスワード再設定メールを送る（send_password_reset_emailはapp/models/user.rbにある）
      @user.send_password_reset_email
      # （インフォで）flashメッセージを表示
      flash[:info] = t('.send_password_reset')
      # rootにリダイレクト
      redirect_to root_url
    # （@userが）存在しなければ
    else
      # （デンジャーで）flashメッセージを表示
      flash.now[:danger] = t('.emailaddress_not_found')
      # newを描画
      render 'new'
    end
  end

  def edit
  end
  
  def update
    # params[:user][:password]がemptyの場合
    if params[:user][:password].empty?
      # @user.errorsに:password, :blankを追加
      @user.errors.add(:password, :blank)
      # editのビューを描画
      render 'edit'
    # 指定された属性の検証がすべて成功した場合@userの更新と保存を続けて同時に行う
    elsif @user.update_attributes(user_params)
      # @userとしてログイン
      log_in @user
      # 成功のフラッシュメッセージを表示
      flash[:success] = t('.password_has_been_reset')
      # ユーザー詳細ページにリダイレクト
      redirect_to @user
    else
      # editのビューを描画
      render 'edit'
    end
  end

  
    private
    #:user必須
    #パスワード、パスワードの確認の属性をそれぞれ許可
    #それ以外は許可しない
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    # beforeフィルタ
    
    # @userに代入　→params[:email]のメールアドレスに対応するユーザー
    def get_user
      @user = User.find_by(email: params[:email])
    end

    # 正しいユーザーかどうか確認する
    def valid_user
      # 条件がfalseの場合（@userが存在する　かつ　@userが有効化されている　かつ　@userが認証済である）
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        # root_urlにリダイレクト
        redirect_to root_url
      end
    end
    
    # トークンが期限切れかどうか確認する
    def check_expiration
      # password_reset_expired→期限切れかどうかを確認するインスタンスメソッド→詳しくは後程
      if @user.password_reset_expired?
        # 再設定の有効期限切れなflashメッセージ
        flash[:danger] = t('.password_reset_has_expired')
        # new_password_reset_urlにリダイレクト
        redirect_to new_password_reset_url
      end
    end
end
