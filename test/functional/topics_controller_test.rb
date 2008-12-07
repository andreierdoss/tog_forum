require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../../tog_user/lib/authenticated_test_helper'

class TopicsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  def setup
    @admin_user = Factory(:user, :login => 'admin_user', :admin => true)
    @normal_user = Factory(:user, :login => 'normal_user', :admin => false)
    @forum = Factory(:forum, :title => "Main Discussion Forum", :user => @admin_user)
    @topic = Factory(:topic, :forum => @forum, :title => "Random Topic", :user => @normal_user)
  end

  context "on GET to :index as normal user" do
    setup do
      login_as @normal_user
      get :index
    end

    should_assign_to :forum
    should_redirect_to "forum_url(@forum)"
  end

  context "on GET to :show" do
    setup do
      login_as @normal_user
      get :show, :forum_id => @forum.id, :id => @topic.id
    end

    should_assign_to :forum
    should_assign_to :topic
    should_assign_to :posts
    should_assign_to :post
    should_respond_with :success
    should_render_template :show
    should_not_set_the_flash
  end

  context "on GET to :new" do
    setup do
      login_as @normal_user
      get :new, :forum_id => @forum.id
    end

    should_assign_to :forum
    should_assign_to :topic
    should_assign_to :post
    should_respond_with :success
    should_render_template :new
    should_render_a_form
    should_not_set_the_flash
  end
  
  context "on POST to :create if logged in" do
    setup do
      login_as @normal_user
      post :create, :forum_id => @forum.id, :topic => { :title => "New Topic Title" }
    end

    should_assign_to :forum
    should_assign_to :topic
    should_redirect_to "forum_topic_url(@topic)" 
    should_set_the_flash_to(/created/i)
  end
  
  context "on POST to :create if NOT logged in" do
    setup do
      post :create, :forum_id => @forum.id, :topic => { :title => "New Topic Title" }
    end

    should_not_assign_to :forum
    should_not_assign_to :topic
    should_redirect_to "new_session_url" 
    should_not_set_the_flash
  end
  
  context "on GET to :edit" do
    setup do
      login_as @normal_user
      get :edit, :forum_id => @forum.id, :id => @topic.id
    end

    should_assign_to :forum
    should_assign_to :topic
    should_respond_with :success
    should_render_template :edit
    should_not_set_the_flash
  end

  context "on PUT to :update when logged in" do
    setup do
      login_as @normal_user
      put :update, :forum_id => @forum.id, :id => @topic.id, :topic => { :title => "New Random Title" }
    end

    should_assign_to :forum
    should_assign_to :topic
    should_redirect_to "forum_topic_url(@topic)" 
    should_set_the_flash_to(/updated/i)
  end

  context "on DELETE to :destroy as admin" do
    setup do
      login_as @admin_user
      delete :destroy, :forum_id => @forum.id, :id => @topic.id
    end

    should_assign_to :forum
    should_redirect_to "forum_url(@forum)" 
    should_set_the_flash_to(/deleted/i)
  end

end
