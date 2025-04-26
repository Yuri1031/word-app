class GroupWord < ApplicationRecord
  belongs_to :user
  belongs_to :group
  belongs_to :word
end
