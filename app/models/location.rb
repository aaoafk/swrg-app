class Location < ApplicationRecord
  belongs_to :meeting
  def self.ransackable_associations(auth_object = nil)
    [ "meeting" ]
  end
  def self.ransackable_attributes(auth_object = nil)
    [ "address", "created_at", "id", "id_value", "meeting_id", "updated_at" ]
  end
end
