class GroupWord < ApplicationRecord
  belongs_to :word
  belongs_to :group
  belongs_to :user
end
