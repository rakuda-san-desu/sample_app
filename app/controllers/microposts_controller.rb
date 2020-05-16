class MicropostsController < ApplicationController
  # 直前にlogged_in_userメソッド（ApplicationController）を実行　:create, :destroyアクションにのみ適用
  before_action :logged_in_user, only: [:create, :destroy]
  
  def create
    # @micropostに　ログイン中のユーザーに紐付いた新しいマイクロポストオブジェクトを返す（引数　micropost_params）
    @micropost = current_user.microposts.build(micropost_params)
    #  @micropostを保存できれば
    if @micropost.save
      # 成功のフラッシュメッセージを表示
      flash[:success] = t('.micropost_created')
      # ルートURLにリダイレクト
      redirect_to root_url
    # 保存できなければ
    else
      # エラー回避
      @feed_items = []
      # static_pages/homeを描画
      render 'static_pages/home'
    end
  end

  def destroy
  end
  
  private

    def micropost_params
      # micropost属性必須　content属性のみ変更を許可
      params.require(:micropost).permit(:content)
    end
end
