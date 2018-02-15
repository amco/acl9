require_relative 'acl_query_mixin'

class ACLQueryMethodNamedTest < ActionDispatch::IntegrationTest
  setup do
    @controller = ACLQueryMethodNamed.new
  end

  test "should respond to :allow_ay" do
    assert @controller.respond_to? :allow_ay
  end

  include ACLQueryMixin
end
