require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  #fixtureのユーザーを読み込む
  def setup
    @user = users(:michael)
  end

  test "login with invalid information" do
    # login_pathにgetのリクエスト
    get login_path
    #sessions/newが描写される
    assert_template 'sessions/new'
    #login_pathにpostのリクエスト　内容→params: { session: { email: "", password: "" } }
    post login_path, params: { session: { email: "", password: "" } }
    #sessions/newが描写される
    assert_template 'sessions/new'
    #falseである　→flashはemptyか？
    assert_not flash.empty?
    #root_pathにgetのリクエスト
    get root_path
    #trueである　→flashはemptyか？
    assert flash.empty?
  end
  
  test "login with valid information followed by logout" do
    #login_pathにgetのリクエスト
    get login_path
    #login_pathにposuのリクエスト　内容→params: { session: { email: @user.email, password: 'password' } }
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    #テストユーザーがログインしている(test_helper.rbのis_logged_in?メソッド)
    assert is_logged_in?
    #ユーザー詳細画面にリダイレクトされる
    assert_redirected_to @user
    #実際にリダイレクト先に移動
    follow_redirect!
    #sers/showが描写される
    assert_template 'users/show'
    #login_pathへのリンクが0である
    assert_select "a[href=?]", login_path, count: 0
    #logout_pathへのリンクがある
    assert_select "a[href=?]", logout_path
    #user_path(@user)へのリンクがある
    assert_select "a[href=?]", user_path(@user)
    #logout_pathへdeleteのリクエスト
    delete logout_path
    #falseである  →テストユーザーがログインしている
    assert_not is_logged_in?
    #ルートURLへリダイレクト
    assert_redirected_to root_url
    #実際にリダイレクト先に移動
    follow_redirect!
    #login_pathへのリンクがある
    assert_select "a[href=?]", login_path
    #logout_pathへのリンクが0である
    assert_select "a[href=?]", logout_path,      count: 0
    #user_path(@user)へのリンクが0である
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end