require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

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
end