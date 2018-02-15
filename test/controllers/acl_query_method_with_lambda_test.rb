require_relative 'acl_query_mixin'

class ACLQueryMethodWithLambdaTest < ActionDispatch::IntegrationTest
  setup do
    @controller = ACLQueryMethodWithLambda.new
  end

  test "should respond to :acl?" do
    assert @controller.respond_to? :acl?
  end

  include ACLQueryMixin
end
