class Forum < ActiveRecord::Base    
  has_many :topics, :order => "created_at DESC", :dependent => :destroy
  has_many :posts, :through => :topics, :source => :posts, :order => "created_at DESC"
  validates_presence_of :title
  
end