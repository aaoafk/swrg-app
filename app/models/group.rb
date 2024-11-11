class Group < ApplicationRecord
  has_many :group_memberships
  has_many :users, through: :group_memberships
  has_many :meetings
  
  enum :group_type, { basic: 0, reading_group: 1 }
end
