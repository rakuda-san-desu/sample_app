require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  # テストユーザーを設定
  def setup
    @user = users(:michael)
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

end
