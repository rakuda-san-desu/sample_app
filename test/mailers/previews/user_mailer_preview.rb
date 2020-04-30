# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at
  # https://5f7b98a0b66149149ecd6edabf11f3d6.vfs.cloud9.ap-northeast-1.amazonaws.com/rails/mailers/user_mailer/account_activation
  def account_activation
    # userにDBの1番目のユーザーを代入
    user = User.first
    # userのactivation_tokenに新しい有効化トークンを代入
    user.activation_token = User.new_token
    # UserMailerクラスのaccount_activationメソッドを呼び出し（引数にuserを渡す）
    UserMailer.account_activation(user)
  end

  # Preview this email at
  # https://5f7b98a0b66149149ecd6edabf11f3d6.vfs.cloud9.ap-northeast-1.amazonaws.com/rails/mailers/user_mailer/password_reset
  def password_reset
    # userにDBの一番目のユーザーを代入
    user = User.first
    # userのreset_tokenに新しい有効化トークンを代入
    user.reset_token = User.new_token
    # UserMailerクラスのpassword_resetメソッドを呼び出し（引数にuserを渡す）
    UserMailer.password_reset(user)
  end
end