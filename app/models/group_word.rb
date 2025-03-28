class GroupWord < ApplicationRecord
  belongs_to :word
  belongs_to :group
end
