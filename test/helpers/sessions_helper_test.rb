require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  #リスト1.2、fixtureでuser変数を定義してrememberメソッドで記憶
  def setup
    @user = users(:michael)
    remember(@user)
  end
  
  #リスト3、current_userが、渡されたユーザーと同じであるか確認
  test "current_user returns right user when session is nil" do
    # @userとcurrent_userが等しければtrue
    assert_equal @user, current_user
    #テストユーザーがログインであればtrue
    assert is_logged_in?
  end

  #ユーザーの記憶ダイジェストが記憶トークンと正しく対応していない場合に現在のユーザーがnilになるか
  test "current_user returns nil when remember digest is wrong" do
    #@userのremember_digestをUser.digest(User.new_token)の値に更新して保存
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    #current_userがnilの時true
    assert_nil current_user
  end
end