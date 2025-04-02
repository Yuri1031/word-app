class Group < ApplicationRecord
  has_many :users, through: :group_members
  has_many :group_members, dependent: :destroy
  has_many :group_words, dependent: :destroy
  has_many :words, through: :group_words
  has_one_attached :group_img
  
  # search info
  def self.ransackable_attributes(auth_object = nil)
    ["group_name"]
  end
end
