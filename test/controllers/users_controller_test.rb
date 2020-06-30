require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  # テストユーザーを設定
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end
  
  test "should redirect index when not logged in" do
    # users_pathにgetのリクエスト
    get users_path
    # login_urlにリダイレクトされる
    assert_redirected_to login_url
  end
  
  test "should get new" do
    get signup_path
    assert_response :success
  end
  
  test "should redirect edit when not logged in" do
    # edit_user_path(@user)にgetのリクエスト
    get edit_user_path(@user)
    # flashがemptyではない（flashが表示されている→エラー表示）
    assert_not flash.empty?
    # login_urlにリダイレクトされる
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    # paramsハッシュに以下のデータを持たせてuser_path(@user)にpatchのリクエスト
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    # flashがemptyではない（flashが表示されている→エラー表示）
    assert_not flash.empty?
    # login_urlにリダイレクトされる
    assert_redirected_to login_url
  end
  
  test "should not allow the admin attribute to be edited via the web" do
    #@other_userとしてログイン（(test_helper.rbで定義したlog_in_asヘルパー)
    log_in_as(@other_user)
    #@other_userのadmin?はtrueではない
    assert_not @other_user.admin?
    #user_path(@other_user)にpatchのリクエスト　→持たせるハッシュ
    patch user_path(@other_user), params: {
                                    user: { password:              'password',
                                            password_confirmation: 'password',
                                            admin: true } }
    #DBから再度取得した@other_userのadmin?はtrueではない
    assert_not @other_user.reload.admin?
  end
  
  test "should redirect edit when logged in as wrong user" do
    # @other_userとしてログインする
    log_in_as(@other_user)
    # @userのユーザー情報編集ページにgetのリクエスト
    get edit_user_path(@user)
    # フラッシュがemptyである
    assert flash.empty?
    # root_urlにリダイレクトされる
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    # @other_userとしてログインする
    log_in_as(@other_user)
    # @userのupdateアクションにparamsハッシュのデータを持たせてPATCHのリクエスト　　
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    # フラッシュがemptyである
    assert flash.empty?
    # root_urlにリダイレクトされる
    assert_redirected_to root_url
  end
  
  test "should redirect destroy when not logged in" do
    # ブロックで渡されたものを呼び出す前後でUser.countに違いがない
    assert_no_difference 'User.count' do
      # user_path(@user)にdeleteのリクエスト
      delete user_path(@user)
    end
    # login_urlにリダイレクトされる
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    # other_userでログインする
    log_in_as(@other_user)
    # ブロックで渡されたものを呼び出す前後でUser.countに違いがない
    assert_no_difference 'User.count' do
      # user_path(@user)にdeleteのリクエスト
      delete user_path(@user)
    end
    # root_urlにリダイレクト
    assert_redirected_to root_url
  end
  
  test "should redirect following when not logged in" do
    # /users/@userのid/followingへgetのリクエスト
    get following_user_path(@user)
    # login_urlへリダイレクト
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    # /users/@userのid/followersへgetのリクエスト
    get followers_user_path(@user)
    # login_urlへリダイレクト
    assert_redirected_to login_url
  end
end
