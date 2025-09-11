require "test_helper"

class Admin::RolesControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "should get index" do
    get admin_roles_url
    assert_response :success
  end

  test "should get show" do
    get admin_role_url(@test_role)
    assert_response :success
  end

  test "should get new" do
    get new_admin_role_url
    assert_response :success
  end

  test "should get create" do
    post admin_roles_url, params: { role: { name: "New role", description: "testing role" } }
    assert_response :redirect
  end

  test "should get edit" do
    get edit_admin_role_url(@test_role)
    assert_response :success
  end

  test "should get update" do
    patch admin_role_url(@test_role), params: { role: { name: "Updated Name" } }
    assert_response :redirect
  end

  test "should get destroy" do
    delete admin_role_url(@test_role)
    assert_response :redirect
  end

end
