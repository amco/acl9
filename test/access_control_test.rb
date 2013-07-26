require 'test_helper'
require File.join(File.dirname(__FILE__), '..', 'lib', 'acl9')
require 'support/controllers'

#######################################################################

class Admin
  def has_role?(role, obj = nil)
    role == "admin"
  end
end

class OwnerOfFoo
  def has_role?(role, obj)
    role == 'owner' && obj == MyDearFoo.instance
  end
end

class Bartender
  def has_role?(role, obj)
    role == 'bartender' && obj == ACLIvars::VenerableBar
  end
end

class TheOnlyUser
  include Singleton

  def has_role?(role, subj)
    role == "the_only_one"
  end
end

class Beholder
  def initialize(role)
    @role = role.to_s
  end

  def has_role?(role, obj)
    role.to_s == @role
  end
end

#######################################################################

module BaseTests
  # permit anonymous to index and show and admin everywhere else
  def self.included(klass)
    klass.class_eval do
      [:index, :show].each do |act|
        it "should permit anonymous to #{act}" do
          get act
          @response.body.should == 'OK'
        end
      end

      [:new, :edit, :update, :delete, :destroy].each do |act|
        it "should forbid anonymous to #{act}" do
          get act
          @response.body.should == 'AccessDenied'
        end
      end

      [:index, :show, :new, :edit, :update, :delete, :destroy].each do |act|
        it "should permit admin to #{act}" do
          get act, :user => Admin.new
          @response.body.should == 'OK'
        end
      end
    end
  end
end

module ShouldRespondToAcl
  def self.included(klass)
    klass.class_eval do
      it "should add :acl as a method" do
        @controller.should respond_to(:acl)
      end

      it "should_not add :acl? as a method" do
        @controller.should_not respond_to(:acl?)
      end
    end
  end
end

#######################################################################

class ACLBlockTest < ActionController::TestCase
  describe 'ACLBlock' do
    include BaseTests
  end
end

class ACLMethodTest < ActionController::TestCase
  describe 'ACLMethod' do
    include BaseTests
    include ShouldRespondToAcl
  end
end

class ACLMethod2Test < ActionController::TestCase
  describe 'ACLMethod2' do
    include BaseTests
    include ShouldRespondToAcl
  end
end

class ACLArgumentsTest < ActionController::TestCase
  describe 'ACLArguments' do
    include BaseTests
  end
end

class ACLBooleanMethodTest < ActionController::TestCase
  describe 'ACLBooleanMethod' do
    include BaseTests
  end
end

class ACLIvarsTest < ActionController::TestCase
  describe 'ACLIvars' do

    it "should allow owner of foo to destroy" do
      delete :destroy, :user => OwnerOfFoo.new
      @response.body.should == 'OK'
    end

    it "should allow bartender to destroy" do
      delete :destroy, :user => Bartender.new
      @response.body.should == 'OK'
    end
  end
end

class ACLSubjectMethodTest < ActionController::TestCase
  describe 'ACLSubjectMethod' do
    it "should allow the only user to index" do
      get :index, :user => TheOnlyUser.instance
      @response.body.should == 'OK'
    end

    it "should deny anonymous to index" do
      get :index
      @response.body.should == 'AccessDenied'
    end
  end
end

class ACLObjectsHashTest < ActionController::TestCase
  describe 'ACLObjectsHash' do
    it "should consider objects hash and prefer it to @ivar" do
      get :allow, :user => OwnerOfFoo.new
      @response.body.should == 'OK'
    end

    it "should return AccessDenied when not logged in" do
      get :allow
      @response.body.should == 'AccessDenied'
    end
  end
end

class ACLActionOverrideTest < ActionController::TestCase
  describe 'ACLActionOverride' do
    it "should allow index action to anonymous" do
      get :check_allow, :_action => :index
      @response.body.should == 'OK'
    end

    it "should deny show action to anonymous" do
      get :check_allow, :_action => :show
      @response.body.should == 'AccessDenied'
    end

    it "should deny edit action to regular user" do
      get :check_allow_with_foo, :_action => :edit, :user => TheOnlyUser.instance

      @response.body.should == 'AccessDenied'
    end

    it "should allow edit action to owner of foo" do
      get :check_allow_with_foo, :_action => :edit, :user => OwnerOfFoo.new
      @response.body.should == 'OK'
    end
  end
end

class ACLHelperMethodTest < ActionController::TestCase
  describe 'ACLHelperMethod' do
    it "should return OK checking helper method" do
      get :allow, :user => OwnerOfFoo.new
      @response.body.should == 'OK'
    end

    it "should return AccessDenied when not logged in" do
      get :allow
      @response.body.should == 'AccessDenied'
    end
  end
end

#######################################################################

module ACLQueryMixin
  def self.included(base)
    base.class_eval do
      describe "#acl_question_mark" do      # describe "#acl?" doesn't work
        before do
          @editor = Beholder.new(:editor)
          @viewer = Beholder.new(:viewer)
          @owneroffoo = OwnerOfFoo.new
        end

        [:edit, :update, :destroy].each do |meth|
          it "should return true for editor/#{meth}" do
            @controller.current_user = @editor
            @controller.acl?(meth).should == true
            @controller.acl?(meth.to_s).should == true
          end

          it "should return false for viewer/#{meth}" do
            @controller.current_user = @viewer
            @controller.acl?(meth).should == false
            @controller.acl?(meth.to_s).should == false
          end
        end

        [:index, :show].each do |meth|
          it "should return false for editor/#{meth}" do
            @controller.current_user = @editor
            @controller.acl?(meth).should == false
            @controller.acl?(meth.to_s).should == false
          end

          it "should return true for viewer/#{meth}" do
            @controller.current_user = @viewer
            @controller.acl?(meth).should == true
            @controller.acl?(meth.to_s).should == true
          end
        end

        it "should return false for editor/fooize" do
          @controller.current_user = @editor
          @controller.acl?(:fooize).should == false
        end

        it "should return true for foo owner" do
          @controller.current_user = @owneroffoo
          @controller.acl?(:fooize, :foo => MyDearFoo.instance).should == true
        end
      end
    end
  end
end

class ACLQueryMethodTest < ActionController::TestCase
  describe 'ACLQueryMethod' do
    it "should respond to :acl?" do
      @controller.should respond_to(:acl?)
    end
    include ACLQueryMixin
  end
end

class ACLQueryMethodWithLambdaTest < ActionController::TestCase
  describe 'ACLQueryMethodWithLambda' do
    it "should respond to :acl?" do
      @controller.should respond_to(:acl?)
    end
    include ACLQueryMixin
  end
end

#######################################################################

class ACLNamedQueryMethodTest < ActionController::TestCase
  describe 'ACLNamedQueryMethod' do
    it "should respond to :allow_ay" do
      @controller.should respond_to(:allow_ay)
    end
    include ACLQueryMixin
  end
end

#######################################################################

class ArgumentsCheckingTest < ActiveSupport::TestCase
  def arg_err(&block)
    lambda do
      block.call
    end.should raise_error(ArgumentError)
  end

  describe 'ArgumentsCheckingTest' do
    it "should raise ArgumentError without a block" do
      arg_err do
        class FailureController < ApplicationController
          access_control
        end
      end
    end

    it "should raise ArgumentError with 1st argument which is not a symbol" do
      arg_err do
        class FailureController < ApplicationController
          access_control 123 do end
        end
      end
    end

    it "should raise ArgumentError with more than 1 positional argument" do
      arg_err do
        class FailureController < ApplicationController
          access_control :foo, :bar do end
        end
      end
    end

    it "should raise ArgumentError with :helper => true and no method name" do
      arg_err do
        class FailureController < ApplicationController
          access_control :helper => true do end
        end
      end
    end

    it "should raise ArgumentError with :helper => :method and a method name" do
      arg_err do
        class FailureController < ApplicationController
          access_control :meth, :helper => :another_meth do end
        end
      end
    end
  end
end

