class User < ApplicationRecord
  has_many :sessions, dependent: :destroy
  has_many :group_memberships, dependent: :destroy
  has_many :groups, through: :group_memberships

  enum :role, { reader: 0, admin: 1, host: 2 }

  validates :email, presence: true,
                   uniqueness: true,
                   format: { with: URI::MailTo::EMAIL_REGEXP }

  # KIM this is required for ActiveAdmin
  def display_name
    "#{first_name} #{last_name}"
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "email", "first_name", "id", "id_value", "last_name", "onboarded", "role", "updated_at" ]
  end
end
