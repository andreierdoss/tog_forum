module TogForum
  class Forum < ActiveRecord::Base    
    set_table_name "tog_forum_forums"
    
    white_list :only => [ :title ]
    
    belongs_to :user
    has_many :topics, :class_name => "TogForum::Topic", :order => "created_at DESC", :dependent => :destroy
    has_many :posts, :through => :topics, :source => :posts, :order => "created_at DESC"
    validates_presence_of :title, :user_id

    def validate
      errors.add(:user_id, "must be an administrator") unless user and user.admin?
    end
  
    def self.top_level
      self.find(:first, :order => "updated_at DESC")
    end
    
    ## if your site depends on a single forum existing (has a flat structure of topics -> posts)
    ## this method will be called if no forum can be found 
    ## this is a configurable option config["plugins.tog_forum.ensure_top_level"]
    def self.create_top_level
      forum_title = Tog::Config['plugins.tog_core.site.name']
      self.create(:title => forum_title, :user => User.find_admin)
    end
  end
end