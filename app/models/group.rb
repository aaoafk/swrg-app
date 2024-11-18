class Group < ApplicationRecord
  has_many :group_memberships, dependent: :destroy
  has_many :users, through: :group_memberships
  has_many :meetings, dependent: :destroy

  enum :group_type, { basic: 0, reading_group: 1 }

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "group_type", "id", "id_value", "max_size", "name", "updated_at" ]
  end

  def full?
    return false if max_size == -1
    users.count >= max_size
  end


  def upcoming_meetings
    meetings.where("date > ?", Time.current).order(date: :asc)
  end
end
