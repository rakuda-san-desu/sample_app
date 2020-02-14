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

end
