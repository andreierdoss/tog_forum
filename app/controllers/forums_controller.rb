class ForumsController < ApplicationController
  before_filter :admin?, :except => [:index, :show]   
  before_filter :login_required, :except => [:index, :show]   
  before_filter :find_forum, :only => [:show, :edit, :update, :destroy]

  # GET /forums
  # GET /forums.xml
  def index
    if admin?
      index_for_admin
    else
      @forum = Forum.find_top_level
      render :action => "show"
    end
  end
  
  def index_for_admin
    @page = params[:page] || '1'
    @forums = Forum.all.paginate  :per_page => 10,
                                  :page => @page,
                                  :order => "created_at desc"
    respond_to do |format|
      format.html
      format.rss { render :rss => @forums }    
    end
  end

  # GET /forums/1
  # GET /forums/1.xml
  def show
    @page = params[:page] || '1'
    @forum = Forum.find(:first) unless @forum
    
    @topics = @forum.topics.paginate :per_page => 10,
                                     :page => @page,
                                     :order => "created_at desc"
    
    
    respond_to do |format|
      format.html # show.html.erb
      format.rss { render :rss => @forum }
    end
  end

  # GET /forums/new
  # GET /forums/new.xml
  def new
    @forum = Forum.new

    respond_to do |format|
      format.html # new.html.erb
      format.rss { render :rss => @forum }
    end
  end

  # GET /forums/1/edit
  def edit
    respond_to do |format|
      format.html 
      format.rss { render :rss => @forum }
    end
  end

  # POST /forums
  # POST /forums.xml
  def create
    @forum = Forum.new(params[:forum])
    @forum.user = current_user

    respond_to do |format|
      if @forum.save
        flash[:notice] = 'The forum was successfully created.'
        format.html { redirect_to(forum_url(@forum)) }
        format.rss { render :rss => @forum, :status => :created, :location => @forum }
      else
        format.html { render :action => "new" }
        format.rss { render :rss => @forum.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /forums/1
  # PUT /forums/1.xml
  def update
    respond_to do |format|
      if @forum.update_attributes(params[:forum])
        flash[:notice] = 'The forum was successfully updated.'
        format.html { redirect_to(forum_url(@forum)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.rss { render :rss => @forum.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /forums/1
  # DELETE /forums/1.xml
  def destroy
    @forum = Forum.find(params[:id])
    @forum.destroy

    respond_to do |format|
      format.html { redirect_to(forums_url) }
      format.xml  { head :ok }
    end
  end

private
  def find_forum
    @forum = Forum.find(params[:id]) if params[:id]
  end
end
