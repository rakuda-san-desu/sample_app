require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  test "layout links when not logged in" do
    # root_pathへgetのリクエスト
    get root_path
    # static_pages/homeが描画される
    assert_template 'static_pages/home'
    # 特定のHTMLタグが存在する　タグの種類(a href), リンク先のパス, タグの数
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", signup_path
    assert_select "a[href=?]", login_path
    # contact_pathにgetのリクエスト
    get contact_path
    # 特定のHTMLタグが存在する　タグの種類（title）, タイトルの文字（full_titleヘルパーを呼び出し）
    assert_select "title", full_title("Contact")
    # signup_pathにgetのリクエスト
    get signup_path
    # 特定のHTMLタグが存在する　タグの種類（title）, タイトルの文字（full_titleヘルパーを呼び出し）
    assert_select "title", full_title("Sign up")
  end
  
  # 以下のテスト直前に@userにusers(:michael)を代入
  def setup
    @user = users(:michael)
  end
  
  test "layout links when logged in" do
    # ログインする
    log_in_as(@user)
    # root_pathへgetのリクエスト
    get root_path
    # static_pages/homeが描画される
    assert_template 'static_pages/home'
    # 特定のHTMLタグが存在する　タグの種類(a href), リンク先のパス, タグの数
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user) 
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    # 特定のHTMLタグが存在する→ strong id="following"
    assert_select 'strong#following'
    # 描写されたページに@user.following.countを文字列にしたものが含まれる
    assert_match @user.following.count.to_s, response.body
    # 特定のHTMLタグが存在する→ strong id="followers"
    assert_select 'strong#followers'
    # 描写されたページに@user.followers.countを文字列にしたものが含まれる
    assert_match @user.followers.count.to_s, response.body
  end
end