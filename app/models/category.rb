class Category < ApplicationRecord
  belongs_to :user
  has_many :words, dependent: :destroy
  has_one_attached :category_img  

  validates :category_name, presence: true

  def marked?
    words.joins(:word_marks).exists?
  end

  # search info
  def self.ransackable_associations(auth_object = nil)
    ["words", "user"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["category_name", "created_at", "updated_at", "id", "user_id"]
  end
end
