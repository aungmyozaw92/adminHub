# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Starting database seeding..."

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
