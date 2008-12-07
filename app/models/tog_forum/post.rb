module TogForum
  class Post < ActiveRecord::Base
    set_table_name "tog_forum_posts"
    
    belongs_to :user
    belongs_to :topic, :class_name => "TogForum::Topic"
    validates_length_of :body, :minimum => 4
    validates_presence_of :body

    acts_as_voteable

    def after_create
      topic.update_attributes :last_post_at => created_at,
                              :last_post_by => user_id
    end
    
    def poster_profile
      self.user.profile rescue nil
    end

  end
end