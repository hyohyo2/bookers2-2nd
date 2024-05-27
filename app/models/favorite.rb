class Favorite < ApplicationRecord
  
  belongs_to :user
  belongs_to :book
  has_one :notification, as: :notifiable, dependent: :destroy
  
  # ユーザが一つの投稿に対して１度しかいいねを押せないようにする
  validates :user_id, uniqueness: {scope: :book_id}
  
  after_create do
    create_notification(user_id: book.user_id)
  end
  
end
