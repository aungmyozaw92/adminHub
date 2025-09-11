# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Starting database seeding..."

# Create Permissions
puts "🔐 Creating permissions..."
permissions_data = [
  # Dashboard permissions
  { name: "dashboard:read", description: "View dashboard" },
  
  # User permissions
  { name: "users:read", description: "View users" },
  { name: "users:create", description: "Create new users" },
  { name: "users:update", description: "Update user information" },
  { name: "users:delete", description: "Delete users" },
  
  # Role permissions
  { name: "roles:read", description: "View roles" },
  { name: "roles:create", description: "Create new roles" },
  { name: "roles:update", description: "Update role information" },
  { name: "roles:delete", description: "Delete roles" },
  
  # Permission permissions
  { name: "permissions:read", description: "View permissions" },
  { name: "permissions:create", description: "Create new permissions" },
  { name: "permissions:update", description: "Update permission information" },
  { name: "permissions:delete", description: "Delete permissions" },
  
  # Category permissions
  { name: "categories:read", description: "View categories" },
  { name: "categories:create", description: "Create new categories" },
  { name: "categories:update", description: "Update category information" },
  { name: "categories:delete", description: "Delete categories" },
  
  # Profile permissions
  { name: "profile:read", description: "View own profile" },
  { name: "profile:update", description: "Update own profile" }
]

permissions = {}
permissions_data.each do |permission_attrs|
  permission = Permission.find_or_create_by!(name: permission_attrs[:name]) do |p|
    p.description = permission_attrs[:description]
  end
  permissions[permission_attrs[:name].to_sym] = permission
  puts "  ✅ Created permission: #{permission.name}"
end

# Create Roles
puts "📋 Creating roles..."
roles_data = [
  { name: "admin", description: "Full system access with all permissions" },
  { name: "manager", description: "Management access with limited admin permissions" },
  { name: "user", description: "Basic user access with limited permissions" },
  { name: "moderator", description: "Content moderation and user management" }
]

roles = {}
roles_data.each do |role_attrs|
  role = Role.find_or_create_by!(name: role_attrs[:name]) do |r|
    r.description = role_attrs[:description]
  end
  roles[role_attrs[:name].to_sym] = role
  puts "  ✅ Created role: #{role.name}"
end

# Assign permissions to roles
puts "🔗 Assigning permissions to roles..."

# Admin gets all permissions
admin_role = roles[:admin]
admin_role.permissions = Permission.all
puts "  ✅ Assigned all permissions to admin role"

# Manager gets most permissions except role and permission management
manager_permissions = [
  :"dashboard:read", :"users:read", :"users:create", :"users:update", :"users:delete",
  :"roles:read", :"permissions:read", :"categories:read", :"categories:create", :"categories:update",
  :"profile:read", :"profile:update"
]
manager_role = roles[:manager]
manager_permissions.each do |perm_key|
  permission = permissions[perm_key]
  manager_role.add_permission(permission.name) if permission
end
puts "  ✅ Assigned manager permissions"

# User gets basic permissions
user_permissions = [:"profile:read", :"profile:update"]
user_role = roles[:user]
user_permissions.each do |perm_key|
  permission = permissions[perm_key]
  user_role.add_permission(permission.name) if permission
end
puts "  ✅ Assigned user permissions"

# Moderator gets user management permissions
moderator_permissions = [
  :"dashboard:read", :"users:read", :"users:update", :"profile:read", :"profile:update"
]
moderator_role = roles[:moderator]
moderator_permissions.each do |perm_key|
  permission = permissions[perm_key]
  moderator_role.add_permission(permission.name) if permission
end
puts "  ✅ Assigned moderator permissions"

# Create Users
puts "👥 Creating users..."
users_data = [
  {
    name: "Admin User",
    email: "admin@adminhub.com",
    phone: "+1234567890",
    password: "admin123",
    roles: [ :admin ]
  },
  {
    name: "Manager User",
    email: "manager@adminhub.com",
    phone: "+1234567891",
    password: "manager123",
    roles: [ :manager ]
  },
  {
    name: "John Doe",
    email: "john@example.com",
    phone: "+1234567892",
    password: "user123",
    roles: [ :user ]
  },
  {
    name: "Jane Smith",
    email: "jane@example.com",
    phone: "+1234567893",
    password: "user123",
    roles: [ :user, :moderator ]
  },
  {
    name: "Bob Johnson",
    email: "bob@example.com",
    password: "user123",
    roles: [ :user ]
  }
]

users_data.each do |user_attrs|
  user_roles = user_attrs.delete(:roles)

  user = User.find_or_create_by!(email: user_attrs[:email]) do |u|
    u.name = user_attrs[:name]
    u.phone = user_attrs[:phone]
    u.password = user_attrs[:password]
    u.password_confirmation = user_attrs[:password]
  end

  # Assign roles to user
  user_roles.each do |role_name|
    role = roles[role_name]
    unless user.roles.include?(role)
      user.roles << role
      puts "  🔗 Assigned role '#{role.name}' to #{user.name}"
    end
  end

  puts "  ✅ Created user: #{user.name} (#{user.email})"
end

# Create additional test users
puts "🧪 Creating additional test users..."
(1..5).each do |i|
  user = User.find_or_create_by!(email: "testuser#{i}@example.com") do |u|
    u.name = "Test User #{i}"
    u.phone = "+1234567#{900 + i}"
    u.password = "test123"
    u.password_confirmation = "test123"
  end

  # Assign random roles
  random_roles = [ :user, :moderator ].sample(rand(1..2))
  random_roles.each do |role_name|
    role = roles[role_name]
    user.roles << role unless user.roles.include?(role)
  end

  puts "  ✅ Created test user: #{user.name}"
end

puts "🎉 Seeding completed successfully!"
puts ""
puts "📊 Summary:"
puts "  - Roles: #{Role.count}"
puts "  - Users: #{User.count}"
puts "  - User-Role assignments: #{UserRole.count}"
puts ""
puts "🔑 Login credentials:"
puts "  Admin: admin@adminhub.com / admin123"
puts "  Manager: manager@adminhub.com / manager123"
puts "  User: john@example.com / user123"
puts "  User with multiple roles: jane@example.com / user123"
