require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../../tog_user/lib/authenticated_test_helper'

class ForumsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper

  def setup
    @admin_user = Factory(:user, :login => 'admin_user', :admin => true)
    @normal_user = Factory(:user, :login => 'normal_user', :admin => false)
    @forum_top_level = Factory(:forum, :title => "Main Discussion Forum", :user => @admin_user)
  end

 
  context "on GET to :index as normal user" do
    setup do
      login_as @normal_user
      get :index
    end

    should_assign_to :forum
    should_assign_to :topics
    should_respond_with :success
    should_render_template :show
    should_not_set_the_flash
  end

end
