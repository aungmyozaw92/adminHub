class UserRole < ApplicationRecord
  belongs_to :user
  belongs_to :role
  # Validations
  validates :user_id, uniqueness: { scope: :role_id } # prevent duplicate roles for same user
end
