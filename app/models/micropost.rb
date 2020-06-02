class Micropost < ApplicationRecord
  # MicropostとそのUserは belongs_to (1対1) の関係性がある
  belongs_to :user
  # default_scope（順序を指定するメソッド） created_at:を降順にする
  default_scope -> { order(created_at: :desc) }
  # mount_uploader（CarrierWaveへ画像と関連付けたモデルを伝えるメソッド）画像のファイル名の格納先の属性名、,アップローダーのクラス名
  mount_uploader :picture, PictureUploader
  # user_idが存在する
  validates :user_id, presence: true
  # contentが存在する　長さは最大140文字
  validates :content, presence: true, length: { maximum: 140 }
  # 独自のバリデーションを定義するためvalidatesではなくvalidateメソッドを使っている
  # 引数にシンボルを取り、シンボル名に対応したメソッド（picture_size）を呼び出す
  validate  :picture_size

  private

    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, :less_than_5mb)
      end
    end
end
