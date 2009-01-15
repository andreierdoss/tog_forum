# Add your custom routes here.  If in config/routes.rb you would 
# add <tt>map.resources</tt>, here you would add just <tt>resources</tt>

resources :forums do |forum|
  forum.resources :topics, :member => { :vote_for => :post, :vote_against => :post } do |topic|
    topic.resources :posts, :member => { :vote_for => :post, :vote_against => :post }
  end
end

namespace(:admin) do |admin|
  admin.resources :forums
end
