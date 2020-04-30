require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    # deliveries変数に配列として格納されたメールをクリア
    ActionMailer::Base.deliveries.clear
    # @userにusers(:michael)を代入
    @user = users(:michael)
  end

  test "password resets" do
    # new_password_reset_path(password_resets#new)へgetのリクエスト
    get new_password_reset_path
    # password_resets/newを描画
    assert_template 'password_resets/new'
    # password_resets_path（password_resets#create）にpostのリクエスト　無効なemailの値
    post password_resets_path, params: { password_reset: { email: "" } }
    # falseである→　flashがemptyである
    assert_not flash.empty?
    # password_resets/newを描画
    assert_template 'password_resets/new'
    # password_resets_path（password_resets#create）にpostのリクエスト　有効なemailの値
    post password_resets_path,
         params: { password_reset: { email: @user.email } }
    # 引数の値が同じものではない→　@user.reset_digestと@user.reload.reset_digest
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    # 引数の値が等しい　１とActionMailer::Base.deliveriesに格納された配列の数
    assert_equal 1, ActionMailer::Base.deliveries.size
    # falseであるる→　flashがemptyである
    assert_not flash.empty?
    # リダイレクトされる→　root_urlに
    assert_redirected_to root_url
    # userに@userを代入（通常統合テストからはアクセスできないattr_accessorで定義した属性の値にもアクセスできるようになる）
    user = assigns(:user)
    # edit_password_reset（password_resets#edit）にgetのリクエスト（有効なuser.reset_tokenと無効なemailを) 
    get edit_password_reset_path(user.reset_token, email: "")
    # リダイレクトされる→　root_urlに
    assert_redirected_to root_url
    # userの以下のキー（:activated）の値をtoggle!メソッドで反転（無効なユーザーに）
    user.toggle!(:activated)
    # edit_password_reset（password_resets#edit）にgetのリクエスト　（無効なトークンと無効なemailを）
    get edit_password_reset_path(user.reset_token, email: user.email)
    # リダイレクトされる→　root_urlに
    assert_redirected_to root_url
    # userの以下のキー（:activated）の値をtoggle!メソッドで反転（無効なユーザーにしたのをさらに反転して有効なユーザーに）
    user.toggle!(:activated)
    # edit_password_reset（password_resets#edit）にgetのリクエスト　（無効なトークンと有効なemailを）
    get edit_password_reset_path('wrong token', email: user.email)
    # リダイレクトされる→　root_urlに
    assert_redirected_to root_url
    # edit_password_reset（password_resets#edit）にgetのリクエスト（有効なトークンとemailを）
    get edit_password_reset_path(user.reset_token, email: user.email)
    # password_resets/editが描画される
    assert_template 'password_resets/edit'
    # 特定のHTMLタグが存在する→　
    # input name="email" type="hidden" value="michael@example.com"(第2引数のuser.emailが入る)
    assert_select "input[name=email][type=hidden][value=?]", user.email
    # 引数にuser.reset_tokenを持ったpassword_reset_pathにpatchのリクエスト
    # email: user.emailと無効なパスワードとパスワード確認（それぞれの値が合わない）
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "barquux" } }
    # 特定のHTMLタグが存在する→　div id="error_explanation"
    assert_select 'div#error_explanation'
    # 引数にuser.reset_tokenを持ったpassword_reset_pathにpatchのリクエスト
    # email: user.emailと空のパスワード
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "",
                            password_confirmation: "" } }
    # 特定のHTMLタグが存在する→　div id="error_explanation"
    assert_select 'div#error_explanation'
    # 引数にuser.reset_tokenを持ったpassword_reset_pathにpatchのリクエスト
    # email: user.emailと有効なパスワードとパスワード確認
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "foobaz" } }
    # trueである　テストユーザーがログイン（test_helper.rbからメソッドの呼び出し）
    assert is_logged_in?
    # falseである　flashがemptyである
    assert_not flash.empty?
    # userの詳細ページにリダイレクトされる
    assert_redirected_to user
  end
end