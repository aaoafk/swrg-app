class Meeting < ApplicationRecord
  belongs_to :group
  has_one :location
  def self.ransackable_associations(auth_object = nil)
    ["group", "location"]
  end
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "date", "group_id", "id", "id_value", "updated_at"]
  end
end
