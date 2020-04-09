class UserMailer < ApplicationMailer

  def account_activation(user)
    # インスタンス変数を定義
    @user = user
    # user.emailにタイトルが"t('.account_activation_title')"のメールを送信
    mail to: user.email, subject: t('.account_activation_title')
  end

  def password_reset
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
