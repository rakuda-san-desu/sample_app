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