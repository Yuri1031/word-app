class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
         has_one_attached :profile_pic
         has_many :group_members
         has_many :groups, through: :group_members

         validates :name, presence: true
         validates :nickname, presence: true
         validates :color_id, presence: true
         validates :color_id, numericality: { other_than: 0 }

         has_many :words

         extend ActiveHash::Associations::ActiveRecordExtensions
         belongs_to :color

         # friends
         has_many :friendships, class_name: 'Friend', foreign_key: 'user_id'
         has_many :inverse_friendships, class_name: 'Friend', foreign_key: 'friend_id'
         has_many :friends, through: :friendships, source: :friend
         has_many :inverse_friends, through: :inverse_friendships, source: :user
         def friends_count
          (friends + inverse_friends).uniq.count
         end

         # search info
         def self.ransackable_attributes(auth_object = nil)
          ["name", "nickname"]
         end

end
