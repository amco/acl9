require_relative 'acl_query_mixin'

class AclQueryMethodTest < ActionDispatch::IntegrationTest
  setup do
    @controller = AclQueryMethod.new
  end

  test "should respond to :acl?" do
    assert @controller.respond_to? :acl?
  end

  include ACLQueryMixin
end
