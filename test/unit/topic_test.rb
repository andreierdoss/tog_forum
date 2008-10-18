require File.dirname(__FILE__) + '/../test_helper'

class TopicTest < Test::Unit::TestCase
  context "A Topic" do
    
    setup do
      @normal_user = Factory(:user, :login => 'normal_user', :admin => false)
    end

    should "should allow normal user to create topic" do
      topic = Topic.new(:user => @normal_user, :title => "Test Topic Title")
      assert topic.valid?
      assert topic.save
      assert topic.user == @normal_user
    end

    should "should require a title" do
      topic = Topic.new(:user => @normal_user)
      assert !topic.valid?
      assert topic.errors.on(:title)
      assert !topic.save
    end
  end

end