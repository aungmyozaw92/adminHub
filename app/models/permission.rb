class Permission < ApplicationRecord
  has_many :role_permissions, dependent: :destroy
  has_many :roles, through: :role_permissions
  
  validates :name, presence: true, uniqueness: true
  
  scope :for_resource, ->(resource) { where("name LIKE ?", "#{resource}:%") }
  scope :for_action, ->(action) { where("name LIKE ?", "%:#{action}") }
end
