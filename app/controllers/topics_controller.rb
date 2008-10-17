class TopicsController < ApplicationController
  
  before_filter :login_required, :only => [:new, :create]   
  before_filter :admin?, :only => [:destroy] # or post.user?
  before_filter :find_forum
  before_filter :find_topic, :only => [:show, :edit, :update, :destroy]
    
  def index
    respond_to do |format|
      format.html { redirect_to forum_path(@forum) }
      format.xml do
        @topics = @forum.topics.paginate :per_page => 10,
                                         :page => @page,
                                         :order => "created_at desc"
        render :xml => @topics
      end
    end
  end
  
  def edit
  end
  
  def show
    @page = params[:page] || '1'
    @posts = @topic.posts.paginate :per_page => 10,
                                   :page => @page,
                                   :order => "created_at desc"

    respond_to do |format|
      format.html do        
        @post = @topic.posts.build(:user => current_user)
      end
      format.xml { render :xml => @posts }
    end
    
  end  

  def new
    @topic = @forum.topics.build(:user => current_user)
 
    respond_to do |format|
      format.html
      format.xml { render :xml => @topic }
    end
  end
    
  def create
    @topic = @forum.topic.build(params[:topic])

     respond_to do |format|
       if @topic.new_record?
         format.html { render :action => "new" }
         format.xml { render :xml => @topic.errors, :status => :unprocessable_entity }
       else
         flash[:notice] = 'Topic was successfully created.'
         format.html { redirect_to(forum_topic_path(@forum, @topic)) }
         format.xml { render :xml => @topic, :status => :created, :location => forum_topic_url(@forum, @topic) }
       end
     end
  end

  def update
    @topic.update_attributes(params[:topic])
    respond_to do |format|
      if @topic.errors.empty?
        flash[:notice] = 'Topic was successfully updated.'
        format.html { redirect_to(forum_topic_path(@forum, @topic)) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @topic.destroy
 
    respond_to do |format|
      format.html { redirect_to(@forum) }
      format.xml { head :ok }
    end
  end
    
private
  def find_forum
    @forum = Forum.find(params[:forum_id], :include => [:topics, :posts]) if params[:forum_id]
  end

  def find_topic
    @topic = @forum.topics.find(params[:id]) if params[:id]    
  end
  
end
