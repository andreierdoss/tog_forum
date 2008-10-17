class Topic < ActiveRecord::Base    
  belongs_to :user
  belongs_to :forum
  has_many :posts, :dependent => :destroy, :order => "posts.created_at asc"
  has_many :users, :through => :posts
  belongs_to :last_post, :class_name => "Post"
  
  validates_associated :posts, :message => nil
  validates_length_of :title, :minimum => 4
  validates_presence_of :title, :forum_id, :user_id
end
