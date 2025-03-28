class Category < ApplicationRecord
  has_many :words
  has_one_attached :category_img

  validates :category_name, presence: true

  def marked?
    words.joins(:word_marks).exists?
  end
end
