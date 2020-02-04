require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    # test userとしてログイン
    log_in_as(@user)
    # edit_user_path(@user)にgetのリクエスト
    get edit_user_path(@user)
    # users/editが描写される
    assert_template 'users/edit'
    # 無効なparams:を持ったuser_path(@user)でpatch（更新）のリクエスト
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }
    # users/editが描写される
    assert_template 'users/edit'
    #特定のHTMLタグが存在する　class="alert"のdiv,　フォームに4個のエラーがあります
    assert_select "div.alert", "フォームに4個のエラーがあります"
  end
  
  test "successful edit" do
    # test userとしてログイン
    log_in_as(@user)
    # edit_user_path(@user)にgetのリクエスト
    get edit_user_path(@user)
    # users/editが描写される
    assert_template 'users/edit'
    # nameに"Foo Bar"を代入
    name  = "Foo Bar"
    # emailに"foo@bar.com"を代入
    email = "foo@bar.com"
    # 有効なparams:を持ったuser_path(@user)でpatch（更新）のリクエスト
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    # falseである→　flashが空っぽであるか
    assert_not flash.empty?
    # リダイレクトされている　→@user（プロフィールページ）
    assert_redirected_to @user
    # @user（プロフィールページ）を再読み込み
    @user.reload
    # name（入力値）と@user.name（DBの値）が等しい
    assert_equal name,  @user.name
    # email（入力値）と@user.email（DBの値）が等しい
    assert_equal email, @user.email
  end
end