require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
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

    # Find or create test user
    @test_user = User.find_by(email: "john@example.com")
    unless @test_user
      @test_user = User.create!(
        name: "Test User",
        email: "john@example.com",
        password: "password123",
        password_confirmation: "password123"
      )
    end

    # Ensure admin role exists and is assigned
    admin_role = Role.find_by(name: "admin") || Role.create!(name: "admin")
    @admin_user.roles << admin_role unless @admin_user.roles.include?(admin_role)

    post admin_login_url, params: { email: @admin_user.email, password: "admin123" }
  end

  test "should get index" do
    get admin_users_url
    assert_response :success
  end

  test "should get show" do
    get admin_user_url(@test_user)
    assert_response :success
  end

  test "should get new" do
    get new_admin_user_url
    assert_response :success
  end

  test "should get create" do
    post admin_users_url, params: { user: { name: "New User", email: "newuser@example.com", password: "password123" } }
    assert_response :redirect
  end

  test "should get edit" do
    get edit_admin_user_url(@test_user)
    assert_response :success
  end

  test "should get update" do
    patch admin_user_url(@test_user), params: { user: { name: "Updated Name" } }
    assert_response :redirect
  end

  test "should get destroy" do
    delete admin_user_url(@test_user)
    assert_response :redirect
  end
end
