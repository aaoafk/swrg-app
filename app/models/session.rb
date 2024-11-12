class Session < ApplicationRecord
  belongs_to :user
  has_secure_token

  validates :user_agent, presence: true
  validates :ip_address, presence: true
end
