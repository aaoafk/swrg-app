class GroupMembership < ApplicationRecord
  belongs_to :user
  belongs_to :group

  validate :group_not_full
  validates :group_id, uniqueness: { scope: :user_id, message: "You're already a member of this group" }

  def self.ransackable_associations(auth_object = nil)
    ["group", "user"]
  end
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "group_id", "id", "id_value", "updated_at", "user_id"]
  end
  private

  def group_not_full
    if group&.full?
      errors.add(:group, "has reached its maximum capacity")
    end
  end

end
