require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    # @userにmichaelを代入
    @user = users(:michael)
  end

  test "micropost interface" do
    # @userでログイン
    log_in_as(@user)
    # root_pathにgetのリクエスト
    get root_path
    # 特定のHTMLタグが存在する→ class = "pagination"を持つdiv
    assert_select 'div.pagination'
    # 特定のHTMLタグが存在する→ type="file"を持つinput
    assert_select 'input[type="file"]'
    # ブロックで渡されたものを呼び出す前後でMicropost.countに違いがない
    assert_no_difference 'Micropost.count' do
      # microposts_pathにpostのリクエスト　→　micropost: { content: "" }（無効なデータ）
      post microposts_path, params: { micropost: { content: "" } }
    end
    # 特定のHTMLタグが存在する→　id = "error_explanation"を持つdiv
    assert_select 'div#error_explanation'
    # contentに代入　→　"This micropost really ties the room together"
    content = "This micropost really ties the room together"
    # pictureに代入→ fixtureで定義されたファイルをアップロードするメソッド（パス, タイプ）
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    # ブロックで渡されたものを呼び出す前後でMicropost.countが+1
    assert_difference 'Micropost.count', 1 do
      # microposts_pathにpostのリクエスト　→　micropost: { content: content, picture: picture }（有効なデータ）
      post microposts_path, params: { micropost: 
                                { content: content,
                                  picture: picture } }
    end
    # @micropostにpictureが含まれる
    assert assigns(:micropost).picture?
    # root_urlにリダイレクト
    assert_redirected_to root_url
    #　指定されたリダイレクト先に移動
    follow_redirect!
    # 表示されたページのHTML本文すべての中にcontentが含まれている
    assert_match content, response.body 
    # 特定のHTMLタグが存在する→　text: '削除'を持つa
    assert_select 'a', text: '削除'
    # first_micropostに代入　@userのページネーションの1ページ目の1番目のマイクロポスト
    first_micropost = @user.microposts.paginate(page: 1).first
    # ブロックで渡されたものを呼び出す前後でMicropost.countが-1
    assert_difference 'Micropost.count', -1 do
      # micropost_path(first_micropost)にdeleteのリクエスト
      delete micropost_path(first_micropost)
    end
    # user_path(users(:archer))にgetのリクエスト
    get user_path(users(:archer))
    # 特定のHTMLタグが存在する→　text: '削除'を持つaが0個
    assert_select 'a', text: '削除', count: 0
  end
  
    test "micropost sidebar count" do
    # @userでログイン
    log_in_as(@user)
    # root_pathにgetのリクエスト
    get root_path
    # 表示されたページのHTML本文すべての中に　#{@user.microposts.count}個の投稿があります　が含まれている
    assert_match "#{@user.microposts.count}個の投稿があります", response.body
    # other_userに代入 → users(:malory)　（まだマイクロポストを投稿していないユーザー）
    other_user = users(:malory)
    # other_user出pログイン
    log_in_as(other_user)
    # root_pathにgetのリクエスト
    get root_path
    # 表示されたページのHTML本文すべての中に　0個の投稿があります　が含まれている
    assert_match "0個の投稿があります", response.body
    # other_userに紐づいたmicropostを作成（content属性に値"A micropost"をセット）
    other_user.microposts.create!(content: "A micropost")
    # root_pathにgetのリクエスト
    get root_path
    # 表示されたページのHTML本文すべての中に　1個の投稿があります　が含まれている
    # 日本語にしていなければFILL_INは"1 micropost"（micropostsではなく単数形にする）
    assert_match "1個の投稿があります", response.body
  end
end