# app/models/otp_code.rb
class OtpCode < ApplicationRecord
  validates :email, presence: true
  validates :code, presence: true, length: { is: 6 }
  validates :expires_at, presence: true
  
  validate :expires_at_cannot_be_in_past, on: :create

  private

  def expires_at_cannot_be_in_past
    if expires_at.present? && expires_at < Time.current
      errors.add(:expires_at, "Can't be in the past")
    end
  end
end
