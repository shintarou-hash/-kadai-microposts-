class User < ApplicationRecord
  before_save { self.email.downcase! }
  #name_長さが50文字以内/空は許可しない
  #email_長さが255文字以内/空は許可しない/組み合わせチェック/重複を許可しない
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  
  #パスワードをハッシュ化して保存
  has_secure_password
  
  #User と一対多の関係
  has_many :microposts
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user


  def follow(other_user)
    unless self== other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end
  
  def unfollow(other_user)
     relationship = self.relationships.find_by(follow_id: other_user.id)
     relationship.destroy if relationship
  end
  
  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  
  #お気に入り機能
  #ユーザーがお気に入り登録したツイートへ参照
  has_many :favorites
  has_many :likes, through: :favorites, source: :micropost

  
  def favorite(micropost)
    self.favorites.find_or_create_by(micropost_id: micropost.id)
  end
  
  def unfavorite(micropost)
    favorite = self.favorites.find_by(micropost_id: micropost.id)
    favorite.destroy if favorite
  end
  
  def like?(micropost)
    self.likes.include?(micropost)
  end
end