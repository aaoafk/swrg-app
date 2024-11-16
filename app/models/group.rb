class Group < ApplicationRecord
  has_many :group_memberships
  has_many :users, through: :group_memberships
  has_many :meetings

  enum :group_type, { basic: 0, reading_group: 1 }

  def full?
    return false if max_size == -1
    users.count >= max_size
  end

  def upcoming_meetings
    meetings.where('date > ?', Time.current).order(date: :asc)
  end
end
