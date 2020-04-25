class PasswordResetsController < ApplicationController
  # フィルタの内容は下部private以下
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  
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
  
    private

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
end
