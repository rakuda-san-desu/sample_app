require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  test "account_activation" do
    # userにテストユーザーmichaelを代入
    user = users(:michael)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    # "Sample App アカウント認証メール"とmail.subjectが等しい
    assert_equal "Sample App アカウント認証メール", mail.subject
    # [user.email]と mail.toが等しい
    assert_equal [user.email], mail.to
    # ["noreply@example.com"]と mail.fromが等しい
    assert_equal ["noreply@example.com"], mail.from
    # user.nameが本文に含まれている
    assert_match user.name,               mail.text_part.body.encoded
    assert_match user.name,               mail.html_part.body.encoded
    # user.activation_tokenが本文に含まれている
    assert_match user.activation_token,   mail.text_part.body.encoded
    assert_match user.activation_token,   mail.html_part.body.encoded
    # 特殊文字をエスケープしたuser.mailが本文に含まれている
    assert_match CGI.escape(user.email),  mail.text_part.body.encoded
    assert_match CGI.escape(user.email),  mail.html_part.body.encoded
  end
end