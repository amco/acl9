require 'test_helper'

class AclIvarsControllerTest < ActionDispatch::IntegrationTest
  test "owner of foo destroys" do
    assert ( user = User.create ).has_role! :owner, Bar
    assert delete acl_ivar_path(1), params: { user_id: user.id }
    assert_response :ok
  end

  test "bartender at Foo destroys" do
    assert ( user = User.create ).has_role! :bartender, Foo
    assert delete acl_ivar_path(1), params: { user_id: user.id }
    assert_response :ok
  end
end
