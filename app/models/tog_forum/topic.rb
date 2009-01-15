module TogForum
  class Topic < ActiveRecord::Base    
    set_table_name "tog_forum_topics"
    
    white_list :only => [ :title, :body ]
    
    belongs_to :user
    belongs_to :forum, :class_name => "TogForum::Forum"
    has_many :posts, :class_name => "TogForum::Post", :dependent => :destroy, :order => "tog_forum_posts.updated_at asc"
    has_many :users, :through => :posts
  
    validates_associated :posts, :message => nil
    validates_length_of :title, :minimum => 4
    validates_presence_of :title, :forum_id, :user_id, :body
    validates_associated :user
    
    def last_poster
      return self.user if self.posts.blank?
      begin
        self.posts.first.user
      rescue
        self.user
      end
    end
   
    def last_poster_name
      last_poster.login rescue "a user"
    end
    
    def last_post_body
      self.posts.first.body rescue self.body
    end
 
    def poster_profile
      self.user.profile rescue nil
    end

    def paginated_posts(options = {})
      defaults = {:order => "updated_at ASC", :page => options[:page] || 1, :per_page => options[:per_page] || 10}
      posts = self.posts.paginate(:all, defaults.merge(options)) rescue nil
    end
    
    def posts_count
      self.posts.size
    end
  end
end
