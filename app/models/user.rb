class User < ApplicationRecord
  has_many :sessions, dependent: :destroy
  has_many :group_memberships
  has_many :groups, through: :group_memberships
  
  enum :role, { reader: 0, admin: 1, host: 2 }

  validates :email, presence: true, 
                   uniqueness: true,
                   format: { with: URI::MailTo::EMAIL_REGEXP }
end
