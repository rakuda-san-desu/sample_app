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
  
  test "login with valid information" do
    #login_pathにgetのリクエスト
    get login_path
    #login_pathにposuのリクエスト　内容→params: { session: { email: @user.email, password: 'password' } }
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
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
  end
end