class PostsController < ApplicationController
  
  before_filter :login_required, :only => [:new, :create, :destroy, :vote_for, :vote_against]   
  before_filter :admin?, :only => [:destroy] # or post.user?
  before_filter :find_topic
  before_filter :find_post, :only => [:edit, :update, :destroy]

  def show
    # @vote_for_controller_url = url_for({:controller=>"posts", :action=>"vote_for", :id => @post.id, :topic_id => @topic.id, :forum_id => @forum.id})
    # @vote_against_controller_url = url_for({:controller=>"posts", :action=>"vote_against", :id => @post.id, :topic_id => @topic.id, :forum_id => @forum.id})
    
    respond_to do |format|
      format.html
      format.rss { render(:layout => false) }
    end    
  end  
  
  def new
    @page = params[:page] || '1'
    @posts = @topic.posts.paginate :per_page => 10, :page => @page, :order => "updated_at ASC"
    @post = @topic.posts.build(:user => current_user)
    if params[:quote]
      @quoting_post = TogForum::Post.find(params[:quote])
      @post.text = "[quote=\"" + @quoting_post.user.login + "\"]" + @quoting_post.text + "[/quote]"
    end
  end
  
  def create
    @post = @topic.posts.build(params[:post])
    @post.user = current_user
    
    respond_to do |format|
      if @post.save
        flash[:notice] = "Post successfuly created"
        format.html { redirect_to(forum_topic_path(@topic.forum, @topic)) }
        format.xml { render :xml => @topic, :status => :created, :location => forum_topic_url(@topic.forum, @topic) }
      else
        flash[:error] = "Post creation unsuccessful: #{@post.errors.full_messages}"
        format.html { render :action => "new" }
        format.xml { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    respond_to do |format|
      if @post.destroy
        flash[:notice] = "You have deleted the post id ##{@post.id}"
      else
        flash[:error] = "An error occurred while trying to delete post id ##{@post.id}: #{@post.errors.full_messages}"
      end
      format.html { redirect_to forum_topic_path(@topic.forum, @topic) }
      format.xml { head :ok }
    end
  end
  
private
  def find_topic
    @topic = TogForum::Topic.find(params[:topic_id], :include => :posts) if params[:topic_id]    
  end

  def find_post
    @post = TogForum::Post.find(params[:post_id]) if params[:post_id]
    @post ||= TogForum::Post.find(params[:id]) if params[:id]    
  end

end
