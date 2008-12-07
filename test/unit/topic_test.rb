require File.dirname(__FILE__) + '/../test_helper'

class TogForum::TopicTest < Test::Unit::TestCase
  context "A TogForum::Topic" do
    setup do
      @normal_user = Factory(:user, :login => 'normal_user', :admin => false)
      @admin_user = Factory(:user, :login => 'admin_user', :admin => true)
      @forum = Factory(:forum, :title => "Main Discussion Forum", :user => @admin_user)
    end

    should "should allow normal user to create topic" do
      topic = TogForum::Topic.new(:user => @normal_user, :forum => @forum, :title => "Test TogForum::Topic Title")
      assert topic.valid?
      assert topic.save
      assert topic.user == @normal_user
    end

    should "should require a title" do
      topic = TogForum::Topic.new(:title => nil)
      assert !topic.valid?
      assert topic.errors.on(:title)
      assert !topic.save
    end
    
    should "should require a body" do
      topic = TogForum::Topic.new(:body => nil)
      assert !topic.valid?
      assert topic.errors.on(:body)
      assert !topic.save
    end
  end

end