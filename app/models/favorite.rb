class Favorite < ApplicationRecord
  
  belongs_to :user
  belongs_to :book
  
  # ユーザが一つの投稿に対して１度しかいいねを押せないようにする
  validates :user_id, uniqueness: {scope: :book_id}
  
end
