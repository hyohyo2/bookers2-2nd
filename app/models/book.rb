class Book < ApplicationRecord
  
  has_one_attached :image
  
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  
  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }
  
  # ユーザが特定の投稿にいいねをしているか判定する
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
end
