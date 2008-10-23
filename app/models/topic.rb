class Topic < ActiveRecord::Base    
  belongs_to :user
  belongs_to :forum
  has_many :posts, :dependent => :destroy, :order => "posts.created_at desc"
  has_many :users, :through => :posts
  
  validates_associated :posts, :message => nil
  validates_length_of :title, :minimum => 4
  validates_presence_of :title, :forum_id, :user_id
  validates_associated :user

  def last_poster
    self.users.first
  end
  
end
