class Word < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :word_marks, dependent: :destroy

  has_many :group_words, dependent: :destroy
  has_many :groups, through: :group_words

  # search
  def self.ransackable_associations(auth_object = nil)
    ["category", "group_words", "groups", "user", "word_marks"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["title", "question", "answer", "created_at", "updated_at"]
  end
end
