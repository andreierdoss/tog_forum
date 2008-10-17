class User < ActiveRecord::Base
  has_many :topics
  has_many :posts
end
