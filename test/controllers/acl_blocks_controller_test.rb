require 'test_helper'

class AclBlocksControllerTest < ActionDispatch::IntegrationTest
  class_eval do
    test_allowed :get, :index, '/acl_blocks'
    test_allowed :get, :show, '/acl_blocks/1'
    test_denied :get, :new, '/acl_blocks/new'
    test_denied :get, :edit, '/acl_blocks/1/edit'
    test_denied :post, :create, '/acl_blocks'
    test_denied :put, :update, '/acl_blocks/1'
    test_denied :patch, :update, '/acl_blocks/1'
    test_denied :delete, :destroy, '/acl_blocks/1'

    admin = -> (user) { user.has_role! :admin }

    test_allowed :get, :new, '/acl_blocks/new', {}, &admin
    test_allowed :get, :edit, '/acl_blocks/1/edit', {}, &admin
    test_allowed :post, :create, '/acl_blocks', {}, &admin
    test_allowed :put, :update, '/acl_blocks/1', {}, &admin
    test_allowed :patch, :update, '/acl_blocks/1', {}, &admin
    test_allowed :delete, :destroy, '/acl_blocks/1', {}, &admin
  end
end
