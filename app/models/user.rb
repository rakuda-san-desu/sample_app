class User < ApplicationRecord
  # UserとMicropostは has_many (1対多) の関係性がある
  # （ユーザーが削除された時）紐づいているマイクロポストも削除される
  has_many :microposts, dependent: :destroy
  # Userモデルと:active_relationshipsはhas_many (1対多) の関係性がある
  # クラスはRelationship、外部キーはfollower_id、（ユーザーが削除された時）紐づいているactive_relationshipsも削除される
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  # Userモデルと:passive_relationshipsはhas_many (1対多) の関係性がある
  # クラスはRelationship、外部キーはfollowed_id、（ユーザーが削除された時）紐づいているpassive_relationshipsも削除される
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  # Userとfollowingはactive_relationshipsを介して多対多の関係を持っている
  # 関連付け（following）元の名前はfollowed
  has_many :following, through: :active_relationships, source: :followed
  # Userとfollowingはpassive_relationshipsを介して多対多の関係を持っている
  # 関連付け（following）元の名前はfollower　←source: :followerは省略可能
  has_many :followers, through: :passive_relationships, source: :follower
  #仮想の属性:remember_token、:activation_token、:reset_tokenをUserクラスに定義
  attr_accessor :remember_token, :activation_token, :reset_token
  #保存の直前に参照するメソッド
  before_save   :downcase_email
  # データ作成の直前に参照するメソッド
  before_create :create_activation_digest
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  #class << self~endのスコープ内のメソッドはクラスメソッドになる
  class << self
    # 渡された文字列のハッシュ値を返す
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # ランダムなトークンを返す
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    #クラス変数remember_tokenに　User.new_tokenを代入
    self.remember_token = User.new_token
    #validationを無視して更新　（:remember_digest属性にハッシュ化したremember_tokenを値としてセット）
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # トークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # ユーザーのログイン情報を破棄する
  def forget
    #validationを無視して更新（:remember_digestの値をnilに）
    update_attribute(:remember_digest, nil)
  end
  
  # アカウントを有効にする
  def activate
    #指定のカラムを指定の値に、DBに直接上書き保存
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  # パスワード再設定の属性を設定する
  def create_reset_digest
    # （呼び出し先で考えると）@userのreset_tokenに代入→User.new_token
    self.reset_token = User.new_token
    # 指定のカラムを指定の値に、DBに直接上書き保存
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    # reset_sent_atの値（再設定メールの送信時刻）　右辺より早い時刻　2時間前
    reset_sent_at < 2.hours.ago
  end
  
  # feedの定義
  def feed
    Micropost.where(user: following)
             .or(Micropost.where(user_id: id))
  end

  # ユーザーをフォローする
  def follow(other_user)
    # followingの最後にother_userを追加
    following << other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    # active_relationshipsからfollowed_idがother_user.idのデータを取得して削除
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    # followingにother_userが含まれているか
    following.include?(other_user)
  end
    private

    # メールアドレスをすべて小文字にする
    def downcase_email
      self.email.downcase!
    end

    # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token  = User.new_token
      # p self.activation_token
      self.activation_digest = User.digest(activation_token)
      # p self.activation_digest
    end
end