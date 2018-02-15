require 'test_helper'

class AclHelperMethodsControllerTest < ActionDispatch::IntegrationTest
  setup do
    assert @user = User.create
  end

  test "foo owner allowed" do
    assert @user.has_role! :owner, Foo.first_or_create

    assert get allow_acl_helper_methods_path, params: { user_id: @user.id }
    assert_select 'div', 'OK'
  end

  test "another user denied" do
    assert @user.has_role! :owner

    assert get allow_acl_helper_methods_path, params: { user_id: @user.id }
    assert_select 'div', 'OK'
  end

  test "anon denied" do
    assert get allow_acl_helper_methods_path
    assert_select 'div', 'AccessDenied'
  end
end
