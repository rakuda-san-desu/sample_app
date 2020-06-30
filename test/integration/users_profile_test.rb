require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  # ApplicationHelperを読み込む
  include ApplicationHelper

  def setup
    @user = users(:michael)
  end

  test "profile display" do
    # user_path(@user)にgetのリクエスト
    get user_path(@user)
    # テンプレートが描画される　'users/show
    assert_template 'users/show'
    # 特定のHTMLタグが存在する→　title, full_title(@user.name)→@user.name | Ruby on Rails Tutorial Sample App
    assert_select 'title', full_title(@user.name)
    # 特定のHTMLタグが存在する→ h1, text: @user.name
    assert_select 'h1', text: @user.name
    # 特定のHTMLタグが存在する→ h1のタグに含まれるimg.gravatar
    assert_select 'h1>img.gravatar'
    # 特定のHTMLタグが存在する→ strong id="following"
    assert_select 'strong#following'
    # 描写されたページに@user.following.countを文字列にしたものが含まれる
    assert_match @user.following.count.to_s, response.body
    # 特定のHTMLタグが存在する→ strong id="followers"
    assert_select 'strong#followers'
    # 描写されたページに@user.followers.countを文字列にしたものが含まれる
    assert_match @user.followers.count.to_s, response.body
    # 描画されたページに　@userのマイクロポストのcountを文字列にしたものが含まれる　
    assert_match @user.microposts.count.to_s, response.body
    # 特定のHTMLタグが存在する→ class = "pagination"を持つdivが1個
    assert_select 'div.pagination', count: 1
    # @user.micropostsのページネーションの1ページ目の配列を1個ずつ取り出してmicropostに代入
    @user.microposts.paginate(page: 1).each do |micropost|
      # micropostにmicropost.contentが含まれる
      assert_match micropost.content, response.body
    end
  end
end