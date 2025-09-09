require "test_helper"

class Admin::DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Find or create admin user for testing
    @admin_user = User.find_by(email: "admin@adminhub.com")
    unless @admin_user
      @admin_user = User.create!(
        name: "Admin User",
        email: "admin@adminhub.com",
        password: "admin123",
        password_confirmation: "admin123"
      )
    end

    # Ensure admin role exists and is assigned
    admin_role = Role.find_by(name: "admin") || Role.create!(name: "admin")
    @admin_user.roles << admin_role unless @admin_user.roles.include?(admin_role)

    post admin_login_url, params: { email: @admin_user.email, password: "admin123" }
  end

  test "should get index" do
    get admin_dashboard_url
    assert_response :success
  end
end
