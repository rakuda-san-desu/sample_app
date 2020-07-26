# テーブル名.create!　作るデータ→対応するカラムと値
User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
            # 管理者
             admin: true,
             #ユーザーが有効化されている
             activated: true,
             activated_at: Time.zone.now)

# 99回繰り返す（timesメソッド）
99.times do |n|
  # nameに代入　Faker::Name.name
  name  = Faker::Name.name
  # emailに代入　example-#{n+1}@railstutorial.org　←それぞれのアドレスが変わるような指定
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               #ユーザーが有効化されている
              activated: true,
              activated_at: Time.zone.now)
end

# マイクロポストのサンプルを追加
# usersに　Userモデルを　created_atの順に並び替えて　上から6個を（配列として）代入
users = User.order(:created_at).take(6)
# 50回繰り返す
50.times do
  # contetに　Faker::Loremで作ったサンプルを代入（Faker::Loremから文章を5個取り出す）
  content = Faker::Lorem.sentence(5)
  # usersを順番に取り出してブロック内を実行
  # 取り出した要素をuserに代入　userに紐づいたmicropostを作成（content属性に変数contentの値）
  users.each { |user| user.microposts.create!(content: content) }
end

# リレーションシップのサンプルを追加
# usersにすべてのユーザーを代入
users = User.all
# userにUserテーブルの1番目のユーザーを代入
user  = users.first
# followingにusersの3番目～51番目を代入
following = users[2..50]
# followersにusersの4番目～41番目を代入
followers = users[3..40]
# followingを順に取り出してブロック内を実行
# 取り出した要素をfollowedに代入　userがfollowedをフォロー
following.each { |followed| user.follow(followed) }
# followersを順に取り出してブロック内を実行
# 取り出した要素をfollowerに代入　followerがユーザーをフォロー
followers.each { |follower| follower.follow(user) }