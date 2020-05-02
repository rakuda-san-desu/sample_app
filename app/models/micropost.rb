class Micropost < ApplicationRecord
  belongs_to :user
  # user_idが存在する
  validates :user_id, presence: true
  # contentが存在する　長さは最大140文字
  validates :content, presence: true, length: { maximum: 140 }
end
