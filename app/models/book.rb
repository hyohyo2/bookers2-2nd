class Book < ApplicationRecord
  
  has_one_attached :image
  
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy
  
  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }
  
  # ユーザが特定の投稿にいいねをしているか判定する
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  # book検索
  def self.search_for(content, method)
    if method == 'perfect'
      Book.where(title: content)  
    elsif method == 'forward'
      Book.where('title LIKE ?', content + '%' )
    elsif method ==  'backward'
      Book.where('title LIKE ?', '%' + content)
    else
      Book.where('title LIKE ?' '%' + content + '%' )
    end    
  end
  # 通知の作成
  after_create do
    user.followers.each do |follower|
      notifications.create(user_id: follower.id)
    end
  end
end
