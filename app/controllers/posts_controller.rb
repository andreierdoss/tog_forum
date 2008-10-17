class PostsController < ApplicationController
  
  before_filter :login_required, :only => [:new, :create]   
  before_filter :admin?, :only => [:destroy] # or post.user?
  before_filter :find_topic
  before_filter :find_post, :only => [:edit, :update, :destroy]

  def show
    respond_to do |format|
      format.html
      format.rss { render(:layout => false) }
    end    
  end  
  
  def new
    @posts = @topic.last_10_posts
    @post = @topic.posts.build(:user => current_user)
    if params[:quote]
      @quoting_post = Post.find(params[:quote])
      @post.text = "[quote=\"" + @quoting_post.user.login + "\"]" + @quoting_post.text + "[/quote]"
    end
  end
  
private
  def find_topic
    @topic = Topic.find(params[:topic_id], :include => :posts) if params[:topic_id]    
  end

  def find_post
    @post = Post.find(params[:post_id]) if params[:post_id]    
  end

end
