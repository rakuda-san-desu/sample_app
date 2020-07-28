require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  # setupでmichaelを@userに代入、archerを@otherに代入しそれぞれログイン済とする
  def setup
    @user = users(:michael)
    @other = users(:archer)
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
  
  test "should follow a user the standard way" do
    # ブロック内の処理の前後で@user.following.countが1増える
    assert_difference '@user.following.count', 1 do
      # relationships_pathにpostのリクエスト（@other をフォローする）
      post relationships_path, params: { followed_id: @other.id }
    end
  end

  test "should follow a user with Ajax" do
    # ブロック内の処理の前後で@user.following.countが1増える
    assert_difference '@user.following.count', 1 do
      # relationships_pathにAjaxでpostのリクエスト（@other をフォローする）
      post relationships_path, xhr: true, params: { followed_id: @other.id }
    end
  end

  test "should unfollow a user the standard way" do
    # @userが@otherをフォロー
    @user.follow(@other)
    # relationshipに代入　→DBの@userのactive_relationshipsからfollowed_id:が@other.idと一致するデータ
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    # ブロック内の処理の前後で@user.following.countが-1
    assert_difference '@user.following.count', -1 do
      # relationship_pathにdeleteのリクエスト（relationshipを削除する）
      delete relationship_path(relationship)
    end
  end

  test "should unfollow a user with Ajax" do
    # @userが@otherをフォロー
    @user.follow(@other)
    # relationshipに代入　→DBの@userのactive_relationshipsからfollowed_id:が@other.idと一致するデータ
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    # ブロック内の処理の前後で@user.following.countが-1
    assert_difference '@user.following.count', -1 do
      # relationship_pathAjaxでにdeleteのリクエスト（relationshipを削除する）
      delete relationship_path(relationship), xhr: true
    end
  end
  
  test "feed on Home page" do
    # root_pathにgetのリクエスト
    get root_path
    # @userのfeedのページネートの1ページ目から配列をひとつづつ取り出してmicropostに代入
    @user.feed.paginate(page: 1).each do |micropost|
      # response.bodyに特殊文字をエスケープしたmicropost.contentが含まれている
      assert_match CGI.escapeHTML(micropost.content), response.body
    end
  end
end