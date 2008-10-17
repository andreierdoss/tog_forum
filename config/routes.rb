# Add your custom routes here.  If in config/routes.rb you would 
# add <tt>map.resources</tt>, here you would add just <tt>resources</tt>

# resources :tog_mails

resources :forums do |forum|
  forum.resources :topics do |topic|
    topic.resources :posts
  end
end
