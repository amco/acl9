require 'test_helper'

class AclMethod2sControllerTest < ActionDispatch::IntegrationTest
  class_eval do
    test_allowed :get, :index, '/acl_method2s'
    test_allowed :get, :show, '/acl_method2s/1'
    test_denied :get, :new, '/acl_method2s/new'
    test_denied :get, :edit, '/acl_method2s/1/edit'
    test_denied :post, :create, '/acl_method2s'
    test_denied :put, :update, '/acl_method2s/1'
    test_denied :patch, :update, '/acl_method2s/1'
    test_denied :delete, :destroy, '/acl_method2s/1'

    admin = -> (user) { user.has_role! :admin }

    test_allowed :get, :new, '/acl_method2s/new', {}, &admin
    test_allowed :get, :edit, '/acl_method2s/1/edit', {}, &admin
    test_allowed :post, :create, '/acl_method2s', {}, &admin
    test_allowed :put, :update, '/acl_method2s/1', {}, &admin
    test_allowed :patch, :update, '/acl_method2s/1', {}, &admin
    test_allowed :delete, :destroy, '/acl_method2s/1', {}, &admin
  end

  setup do
    @controller = AclMethod2sController.new
  end

  include ShouldRespondToAcl
end
