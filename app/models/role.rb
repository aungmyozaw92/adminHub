class Role < ApplicationRecord
  has_many :user_roles, dependent: :destroy
  has_many :users, through: :user_roles
  has_many :role_permissions, dependent: :destroy
  has_many :permissions, through: :role_permissions
  
  # Validations
  validates :name, presence: true, uniqueness: true
  
  def has_permission?(permission_name)
    permissions.exists?(name: permission_name)
  end
  
  def add_permission(permission_name)
    permission = Permission.find_by(name: permission_name)
    permissions << permission if permission && !has_permission?(permission_name)
  end
  
  def remove_permission(permission_name)
    permission = permissions.find_by(name: permission_name)
    permissions.delete(permission) if permission
  end
end
