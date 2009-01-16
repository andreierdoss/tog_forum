require File.dirname(__FILE__) + '/../../test_helper'
require File.dirname(__FILE__) + '/../../../../tog_user/lib/authenticated_test_helper'

class Admin::ForumsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  def setup
    @admin_user = Factory(:user, :login => 'admin_user', :admin => true)
    @normal_user = Factory(:user, :login => 'normal_user', :admin => false)
    @forum_top_level = Factory(:forum, :title => "Main Discussion Forum", :user => @admin_user)
  end

  context "on GET to :index as admin" do
    setup {
      login_as @admin_user
      get :index
    }

    should_assign_to :forums
    should_respond_with :success
    should_render_template :index
    should_not_set_the_flash
  end
  
  context "on GET to :new as admin" do
    setup do
      login_as @admin_user
      get :new
    end

    should_assign_to :forum
    should_respond_with :success
    should_render_template :new
    should_render_a_form
    should_not_set_the_flash
  end

  context "on GET to :show as admin" do
    setup do
      login_as @admin_user
      get :show, :id => @forum_top_level.id
    end

    should_assign_to :forum
    should_respond_with :success
    should_render_template :"_topics_paginated"
    should_not_set_the_flash
  end
  
  context "on GET to :edit as admin" do
    setup do
      login_as @admin_user
      get :edit, :id => @forum_top_level.id
    end

    should_assign_to :forum
    should_respond_with :success
    should_render_template :edit
    should_not_set_the_flash
  end

  context "on POST to :create as admin" do
    setup do
      login_as @admin_user
      post :create, :forum => { :title => "New Forum Title" }
    end

    should_assign_to :forum
    should_redirect_to "forum_url(@forum)" 
    should_set_the_flash_to(/created/i)
  end
  
  context "on PUT to :update as admin" do
    setup do
      login_as @admin_user
      put :update, :id => @forum_top_level.id, :forum => { :title => "Updated Forum Title" }
    end

    should_assign_to :forum
    should_redirect_to "forum_url(@forum)" 
    should_set_the_flash_to(/updated/i)
  end

  context "on DELETE to :destroy as admin" do
    setup do
      login_as @admin_user
      delete :destroy, :id => @forum_top_level.id
    end

    should_assign_to :forum
    should_redirect_to "forums_url" 
    should_set_the_flash_to(/deleted/i)
  end
end
