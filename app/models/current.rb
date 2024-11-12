# app/models/current.rb
class Current < ActiveSupport::CurrentAttributes
  attribute :session, :user
end
