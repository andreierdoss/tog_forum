require File.dirname(__FILE__) + '/../test_helper'

class TogForum::ForumTest < Test::Unit::TestCase
  context "A TogForum::Forum" do
    
    setup do
      @admin_user = Factory(:user, :login => 'admin_user', :admin => true)
      @normal_user = Factory(:user, :login => 'normal_user', :admin => false)
    end

    should "should allow admin to create forum" do
      forum = TogForum::Forum.new(:user => @admin_user, :title => "Test Title")
      assert forum.valid?
      assert forum.save
      assert forum.user == @admin_user
    end

    should "should not allow normal user to create forum" do
      forum = TogForum::Forum.new(:user => @normal_user, :title => "Test Title")
      assert !forum.valid?
      assert !forum.save
    end

    should "should require a title" do
      forum = TogForum::Forum.new(:user => @admin_user)
      assert !forum.valid?
      assert forum.errors.on(:title)
      assert !forum.save
    end
    
    should "should require a user" do
      forum = TogForum::Forum.new(:user => nil)
      assert !forum.valid?
      assert forum.errors.on(:user_id)
      assert !forum.save
    end
    
    should "find top level forum" do
      @forum_top_level = Factory(:forum, :title => "Main Discussion TogForum::Forum", :user => @admin_user)
      forum = TogForum::Forum.top_level
      assert_equal @forum_top_level, forum
    end
  end

end