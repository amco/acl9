require 'test_helper'

class AclBooleanMethodsControllerTest < ActionDispatch::IntegrationTest
  class_eval do
    test_allowed :get, :index, '/acl_boolean_methods'
    test_allowed :get, :show, '/acl_boolean_methods/1'
    test_denied :get, :new, '/acl_boolean_methods/new'
    test_denied :get, :edit, '/acl_boolean_methods/1/edit'
    test_denied :post, :create, '/acl_boolean_methods'
    test_denied :put, :update, '/acl_boolean_methods/1'
    test_denied :patch, :update, '/acl_boolean_methods/1'
    test_denied :delete, :destroy, '/acl_boolean_methods/1'

    admin = -> (user) { user.has_role! :admin }

    test_allowed :get, :new, '/acl_boolean_methods/new', {}, &admin
    test_allowed :get, :edit, '/acl_boolean_methods/1/edit', {}, &admin
    test_allowed :post, :create, '/acl_boolean_methods', {}, &admin
    test_allowed :put, :update, '/acl_boolean_methods/1', {}, &admin
    test_allowed :patch, :update, '/acl_boolean_methods/1', {}, &admin
    test_allowed :delete, :destroy, '/acl_boolean_methods/1', {}, &admin
  end
end
