require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin     = users(:michael)
    @non_admin = users(:archer)
    @non_activated = users(:non_activated)
  end

  test "index including pagination" do
    # @adminでログイン
    log_in_as(@admin)
    # users_pathにgetのリクエスト
    get users_path
    # users/indexが描画される
    assert_template 'users/index'
    # users(:non_activated)が存在しないことを確認
    # 特定のHTMLタグが存在する a href パスはuser_path(@non_activated) 表示テキストは@non_activated.name カウントは0
    assert_select 'a[href=?]', user_path(@non_activated), text: @non_activated.name, count: 0
    # 特定のHTMLタグが存在する　div class="pagination"
    assert_select 'div.pagination' , count: 2
    # first_page_of_usersにUser.paginate(page: 1)（ユーザー一覧のページ目）を代入
    first_page_of_users = User.paginate(page: 1)
    # first_page_of_usersからuserを1づつ取り出す
    first_page_of_users.each do |user|
      # 特定のHTMLタグが存在する a href パスはuser_path(user) 表示テキストはuser.name
      assert_select 'a[href=?]', user_path(user), text: user.name
      # user == @adminがfalseの場合（管理ユーザー 以 外 に削除の表示がある）
      unless user == @admin
        # 特定のHTMLタグが存在する　a href　パスはuser_path(user)　表示テキストは'削除'
        assert_select 'a[href=?]', user_path(user), text: '削除'
      end
    end
    # ブロックで渡されたものを呼び出す前後でUser.countが-1
    assert_difference 'User.count', -1 do
      # user_path(@non_admin)にdeleteのリクエスト
      delete user_path(@non_admin)
    end
    # user_path(@non_activated)にgetのリクエスト
    get user_path(@non_activated)
    # root_pathにリダイレクトされる
    assert_redirected_to root_path
  end
  
  test "index as non-admin" do
    # @non_adminでログイン
    log_in_as(@non_admin)
    # users_pathにgetのリクエスト
    get users_path
    # 特定のHTMLタグが存在する　a 表示テキストは'削除'　カウントは0個
    assert_select 'a', text: '削除', count: 0
  end
end

