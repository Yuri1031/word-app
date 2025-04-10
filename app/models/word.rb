class Word < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :word_marks, dependent: :destroy

  has_many :group_words, dependent: :destroy
  has_many :groups, through: :group_words

  # search info
  def self.ransackable_attributes(auth_object = nil)
    ["title", "question","answer"]
  end
end
