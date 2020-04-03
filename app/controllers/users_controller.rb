class UsersController < ApplicationController
  # 直前にlogged_in_userメソッドを実行　index,edit,updateアクションにのみ適用
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  # 直前にcorrect_userメソッドを実行　edit,updateアクションにのみ適用
  before_action :correct_user,   only: [:edit, :update]
  # 直前にadmin_userメソッドを実行　destroyアクションのみに適用
  before_action :admin_user,     only: :destroy
  
  def index
    # インスタンス変数@usersに以下を代入
    # Userテーブルからactivated:がtrueのデータをすべて取り出してpaginate(page: params[:page])する
    @users = User.where(activated: true).paginate(page: params[:page])
  end
  
  def show
    # @userにUserテーブルから(params[:id])のデータを取り出して代入
    @user = User.find(params[:id])
    #root_urlにリダイレクト　以下がtrueの場合（審議値を返すreturn）　@userが有効ではない
    #false(@userが有効）な場合はリダイレクトは実行されない
    redirect_to root_url and return unless @user.activated?
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      # userモデルで定義したメソッド（send_activation_email）を呼び出して有効化メールを送信
      @user.send_activation_email
      flash[:info] = t('.check_your_email')
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  #ユーザーのeditアクション
  def edit
    # 直前に実行されるcorrect_userメソッドで定義されているため下記代入文は削除
    # @user = User.find(params[:id])
  end
  
  def update
    # 直前に実行されるcorrect_userメソッドで定義されているため下記代入文は削除
    # @user = User.find(params[:id])
    #指定された属性の検証がすべて成功した場合@userの更新と保存を続けて同時に行う
    if @user.update_attributes(user_params)
      # 更新成功のフラッシュメッセージ
      flash[:success] = t('.profile_updated')
      # @user（プロフィールページ）へリダイレクト
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    # 受け取ったidのUserを削除
    User.find(params[:id]).destroy
    # 削除成功のフラッシュメッセージ
    flash[:success] = t('.user_deleted')
    # ユーザー一覧ページへリダイレクト
    redirect_to users_url
  end
  
  # 外部に公開されないメソッド
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    
    # beforeアクション

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
    
    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      # root_urlにリダイレクト　current_user?メソッドがfalseの場合
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # 管理者かどうか確認
    def admin_user
      # root_urlにリダイレクト current_user.admin?(ログイン中のユーザーが管理者であるか)がfalseの場合
      redirect_to(root_url) unless current_user.admin?
    end
end
