require File.dirname(__FILE__) + '/../test_helper'

class ForumTest < Test::Unit::TestCase
  context "A Forum" do
    
    setup do
      @admin_user = Factory(:user, :login => 'admin_user', :admin => true)
      @normal_user = Factory(:user, :login => 'normal_user', :admin => false)
    end

    should "should allow admin to create forum" do
      forum = Forum.new(:user => @admin_user, :title => "Test Title")
      assert forum.valid?
      assert forum.save
      assert forum.user == @admin_user
    end

    should "should not allow normal user to create forum" do
      forum = Forum.new(:user => @normal_user, :title => "Test Title")
      assert !forum.valid?
      assert !forum.save
    end

    should "should require a title" do
      forum = Forum.new(:user => @admin_user)
      assert !forum.valid?
      assert forum.errors.on(:title)
      assert !forum.save
    end
  end

end