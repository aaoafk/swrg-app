class GroupMembership < ApplicationRecord
  belongs_to :user
  belongs_to :group

  validate :group_not_full
  validates :group_id, uniqueness: { scope: :user_id, message: "You're already a member of this group" }

  private

  def group_not_full
    if group&.full?
      errors.add(:group, "has reached its maximum capacity")
    end
  end
end
