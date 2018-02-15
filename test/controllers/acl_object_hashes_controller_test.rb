require 'test_helper'

class ACLObjectsHashTest < ActionDispatch::IntegrationTest
  setup do
    assert @user = User.create
    assert @user.has_role! :owner, Foo.first_or_create
  end

  test "objects hash preferred to @ivar" do
    assert get allow_acl_objects_hashes_path, params: { user_id: @user.id }
    assert_response :ok
  end

  test "unauthed for no user" do
    assert get allow_acl_objects_hashes_path
    assert_response :unauthorized
  end
end
