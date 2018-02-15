require 'simplecov'
SimpleCov.start

require 'minitest/reporters'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers! if ENV["BACKTRACE"]

ActiveRecord::Migration.verbose = false
ActiveRecord::Migrator.migrate File.expand_path("../dummy/db/migrate/", __FILE__)

class ActionDispatch::IntegrationTest
  class << self
    def test_allowed(method, action, path, params=nil, headers=nil)
      test "allowed #{method} #{action}" do
        if block_given?
          yield user = User.create
          ( params ||= {} ).merge! :user_id => user.id
        end
        assert send(method, path, params: params, headers: headers)
        assert_response :ok
      end
    end

    def test_denied(method, action, path, params=nil, headers=nil)
      test "denied #{method} #{action}" do
        assert_raises Acl9::AccessDenied do
          if block_given?
            yield user = User.create
            ( params ||= {} ).merge! :user_id => user.id
          end
          assert send(method, path, params: params, headers: headers)
        end
      end
    end
  end
end

class ActiveSupport::TestCase
  def assert_equal_elements expected, test, message=nil
    assert_equal [], expected - test, message
  end
end


module ShouldRespondToAcl
  def self.included(klass)
    klass.class_eval do
      test "controller has :acl method" do
        assert @controller.respond_to? :acl
      end

      test "controller has no :acl? method" do
        refute @controller.respond_to? :acl?
      end
    end
  end
end
