require File.dirname(__FILE__) + '/../test_helper'

require File.dirname(__FILE__) + '/../../../tog_user/lib/authenticated_test_helper'
class ForumsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  def setup
    @admin_user = Factory(:user, :login => 'admin_user', :admin => true)
    @normal_user = Factory(:user, :login => 'normal_user', :admin => false)
    @forum_top_level = Factory(:forum, :title => "Main Discussion Forum", :user => @admin_user)
  end
    
  def test_should_get_index_for_admin
    login_as @admin_user
    get :index
    assert_response :success
    assert_not_nil assigns(:forums)
  end

  def test_should_get_index_for_normal_user
    login_as @normal_user
    get :index
    assert_response :success
    assert_not_nil assigns(:forum)
    assert_template "show"
  end

  def test_should_get_new
    login_as @admin_user
    get :new
    assert_response :success
  end

  def test_should_create_forums
    login_as @admin_user
    
    assert_difference(Forum, :count) do
      post :create, :forum => { :title => "New Forum Title" }
    end

    assert_redirected_to forum_path(assigns(:forum))
  end

  def test_should_show_forums
    login_as @admin_user
    get :show, :id => @forum_top_level.id
    assert_response :success
  end

  def test_should_get_edit
    login_as @admin_user
    get :edit, :id => @forum_top_level.id
    assert_response :success
  end

  def test_should_update_forums
    login_as @admin_user
    put :update, :id => @forum_top_level.id, :forum => { }
    assert_redirected_to forum_path(assigns(:forum))
  end

  def test_should_destroy_forums
    login_as @admin_user
    assert_difference(Forum, :count, -1) do
      delete :destroy, :id => @forum_top_level.id
    end

    assert_redirected_to forums_path
  end
end
