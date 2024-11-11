class Meeting < ApplicationRecord
  belongs_to :group
  has_one :location
end
