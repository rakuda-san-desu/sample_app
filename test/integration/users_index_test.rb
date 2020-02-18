require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "index including pagination" do
    # @userでログイン
    log_in_as(@user)
    # users_pathにgetのリクエスト
    get users_path
    # users/indexが描画される
    assert_template 'users/index'
    # 特定のHTMLタグが存在する　div class="pagination"
    assert_select 'div.pagination' , count: 2
    # User.paginate(page: 1)からuserを1づつ取り出す
    User.paginate(page: 1).each do |user|
      # 特定のHTMLタグが存在する a href パスはuser_path(user) 表示テキストはuser.name
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end
end