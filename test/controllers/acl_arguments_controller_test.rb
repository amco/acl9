require 'test_helper'

class AclArgumentsControllerTest < ActionDispatch::IntegrationTest
  class_eval do
    test_allowed :get, :index, '/acl_arguments'
    test_allowed :get, :show, '/acl_arguments/1'
    test_denied :get, :new, '/acl_arguments/new'
    test_denied :get, :edit, '/acl_arguments/1/edit'
    test_denied :post, :create, '/acl_arguments'
    test_denied :put, :update, '/acl_arguments/1'
    test_denied :patch, :update, '/acl_arguments/1'
    test_denied :delete, :destroy, '/acl_arguments/1'

    admin = -> (user) { user.has_role! :admin }

    test_allowed :get, :new, '/acl_arguments/new', {}, &admin
    test_allowed :get, :edit, '/acl_arguments/1/edit', {}, &admin
    test_allowed :post, :create, '/acl_arguments', {}, &admin
    test_allowed :put, :update, '/acl_arguments/1', {}, &admin
    test_allowed :patch, :update, '/acl_arguments/1', {}, &admin
    test_allowed :delete, :destroy, '/acl_arguments/1', {}, &admin
  end
end