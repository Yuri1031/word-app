class Word < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :word_marks

  has_many :group_words, dependent: :destroy
  has_many :groups, through: :group_words
end
