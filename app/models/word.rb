class Word < ApplicationRecord
  belongs_to :category
  has_many :word_marks

  has_many :group_words, dependent: :destroy
  has_many :groups, through: :group_words
end
