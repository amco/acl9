require 'test_helper'

class AclMethodsControllerTest < ActionDispatch::IntegrationTest
  class_eval do
    test_allowed :get, :index, '/acl_methods'
    test_allowed :get, :show, '/acl_methods/1'
    test_denied :get, :new, '/acl_methods/new'
    test_denied :get, :edit, '/acl_methods/1/edit'
    test_denied :post, :create, '/acl_methods'
    test_denied :put, :update, '/acl_methods/1'
    test_denied :patch, :update, '/acl_methods/1'
    test_denied :delete, :destroy, '/acl_methods/1'

    admin = -> (user) { user.has_role! :admin }

    test_allowed :get, :new, '/acl_methods/new', {}, &admin
    test_allowed :get, :edit, '/acl_methods/1/edit', {}, &admin
    test_allowed :post, :create, '/acl_methods', {}, &admin
    test_allowed :put, :update, '/acl_methods/1', {}, &admin
    test_allowed :patch, :update, '/acl_methods/1', {}, &admin
    test_allowed :delete, :destroy, '/acl_methods/1', {}, &admin
  end

  setup do
    @controller = AclMethodsController.new
  end

  include ShouldRespondToAcl
end
