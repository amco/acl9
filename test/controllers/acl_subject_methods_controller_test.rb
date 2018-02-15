require 'test_helper'

class AclSubjectMethodsControllerTest < ActionDispatch::IntegrationTest
  test "allow the only user to index" do
    assert ( user = User.create ).has_role! :the_only_one
    assert get acl_subject_methods_path, params: { user_id: user.id }
    assert_response :ok
  end

  test "deny anonymous to index" do
    assert_raises Acl9::AccessDenied do
      get acl_subject_methods_path
    end
  end
end
