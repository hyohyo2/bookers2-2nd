class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_one_attached :profile_image     
  
  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :notifications, dependent: :destroy
  
  # 一人のユーザに対してフォローしているのは複数
  # モデルの関連付け→任意の名前、クラス→中間テーブル、外部キー→フォローするユーザid、
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # ユーザがフォローしているユーザ一覧を表示のための関連付け
  has_many :followings, through: :active_relationships, source: :followed
  # 一人のユーザに対して複数のフォロワーが存在する
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # ユーザのフォロワーの一覧を取得するための関連付け
  has_many :followers, through: :passive_relationships, source: :follower
  
  # 指定ユーザのフォロー
  def follow(user)
    active_relationships.create(followed_id: user.id)
  end
  # 指定ユーザのフォロー解除
  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end
  # 指定ユーザをフォローしているか判定
  def following?(user)
    followings.include?(user)
  end
  
  GUEST_USER_EMAIL = "guest@example.com"
    def self.guest
      find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
        user.password = SecureRandom.urlsafe_base64
        user.name = "guestuser"
      end
    end
    def guest_user?
      email == GUEST_USER_EMAIL
    end
  
  
  validates :name, presence: true, uniqueness: true, length: { in: 2..20 }
  validates :introduction, length: { maximum: 50 }
  
  
  
  
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/default-image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end
  
  # user検索
  def self.search_for(content, method)
    if method == 'perfect'
      User.where(name: content)  
    elsif method == 'forward'
      User.where('name LIKE ?', content + '%' )
    elsif method ==  'backward'
      User.where('name LIKE ?', '%' + content)
    else
      User.where('name LIKE ?' '%' + content + '%' )
    end    
  end
  
end
