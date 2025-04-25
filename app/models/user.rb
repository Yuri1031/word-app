class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
         has_one_attached :profile_pic
         has_many :group_members
         has_many :groups, through: :group_members
         has_many :owned_groups, class_name: 'Group', foreign_key: 'user_id'
         has_many :categories, dependent: :destroy
         has_many :words
         has_many :group_words
         has_many :categories, through: :words
         has_many :word_marks, dependent: :destroy

         validates :name, presence: true
         validates :nickname, presence: true
         validates :color_id, presence: true
         validates :color_id, numericality: { other_than: 0 }

         extend ActiveHash::Associations::ActiveRecordExtensions
         belongs_to :color

         # relationship (follower,followed)
         has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
         has_many :followings, through: :active_relationships, source: :followed
         has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
         has_many :followers, through: :passive_relationships, source: :follower

         def follow(other_user)
          active_relationships.create(followed_id: other_user.id)
         end

         def unfollow(other_user)
          active_relationships.find_by(followed_id: other_user.id).destroy
         end

         def following?(other_user)
          active_relationships.exists?(followed_id: other_user.id)
         end

         def matchers
          self.followings & self.followers
         end

         def matchers?(other_user)
          following?(other_user) && other_user.following?(self)
         end

         def follow_request_from?(other_user)
          !matchers?(other_user) && other_user.following?(self)
         end

         def matcher_users_relation
          User.where(id: matchers.map(&:id))
         end

        
        
        

         # search
         def self.ransackable_associations(auth_object = nil)
          [
            "active_relationships", "categories", "color", "followers", "followings",
            "group_members", "group_words", "groups", "owned_groups",
            "passive_relationships", "profile_pic_attachment", "profile_pic_blob",
            "word_marks", "words"
          ]
        end
      
        def self.ransackable_attributes(auth_object = nil)
          [
            "id", "nickname", "created_at", "updated_at"
          ]         
        end
end
