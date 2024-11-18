# app/models/announcement.rb
class Announcement < ApplicationRecord
  scope :current, -> { where(active: true).where('start_at <= ? AND (end_at IS NULL OR end_at >= ?)', Time.current, Time.current) }
  def self.ransackable_attributes(auth_object = nil)
    ["active", "body", "created_at", "end_at", "id", "start_at", "title", "updated_at"]
  end
end
