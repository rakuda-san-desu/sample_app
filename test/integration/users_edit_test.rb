require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
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
  end
end