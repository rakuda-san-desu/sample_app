require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  # setupでmichaelを@userに代入ログイン済とする
  def setup
    @user = users(:michael)
    log_in_as(@user)
  end

  test "following page" do
    # /users/@userのid/followingにgetのリクエスト
    get following_user_path(@user)
    # falseである→　@user.followingがempty
    assert_not @user.following.empty?
    # tureである→ @user.followingのcountを文字列にしたものが本文に一致
    assert_match @user.following.count.to_s, response.body
    # @user.followingを順に取り出してuserに代入
    @user.following.each do |user|
      # 特定のHTMLタグが存在する→ a href = "/users/userのid"
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "followers page" do
    # /users/@userのid/followersにgetのリクエスト
    get followers_user_path(@user)
    # falseである→　@user.followersがempty
    assert_not @user.followers.empty?
    # tureである→ @user.followersのcountを文字列にしたものが本文に一致
    assert_match @user.followers.count.to_s, response.body
    # @user.followersを順に取り出してuserに代入
    @user.followers.each do |user|
      # 特定のHTMLタグが存在する→ a href = "/users/userのid"
      assert_select "a[href=?]", user_path(user)
    end
  end
end