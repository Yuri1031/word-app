class Group < ApplicationRecord
  belongs_to :user
  
  has_many :group_members, dependent: :destroy
  has_many :users, through: :group_members
  
  has_many :group_words, dependent: :destroy
  has_many :words, through: :group_words

  has_one_attached :group_img
  
  # search info
  def self.ransackable_associations(auth_object = nil)
    ["group_members", "group_words", "user", "users", "words", "group_img_attachment", "group_img_blob"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["group_name", "group_description", "created_at", "updated_at", "id", "user_id"]
  end
  
end
