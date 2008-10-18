class ForumsController < ApplicationController

  before_filter :admin?, :except => [:index, :show]   
  before_filter :find_forum, :only => [:show, :edit, :update, :destroy]
  
  def index
    @page = params[:page] || '1'
    @forums = Forum.all.paginate  :per_page => 10,
                                  :page => @page,
                                  :order => "created_at desc"
    
    respond_to do |format|
      format.html
      format.rss { render :rss => @forums }
    end    
  end

  def show
    @page = params[:page] || '1'
    
    @topics = @forum.topics.paginate :per_page => 10,
                                     :page => @page,
                                     :order => "created_at desc"
    
    respond_to do |format|
      format.html
      format.rss { render :rss => @forum }
    end    
  end
  
  def new
    @forum = Forum.new
 
    respond_to do |format|
      format.html 
      format.xml { render :xml => @forum }
    end
  end
  
  def edit
    respond_to do |format|
      format.html 
      format.xml { render :xml => @forum }
    end
  end
  
  def create
    @forum = Forum.new(params[:forum])
    @forum.user = current_user

    respond_to do |format|
      if @forum.save
        flash[:notice] = 'Forum was successfully created.'
        format.html { redirect_to(@forum) }
        format.xml { render :xml => @forum, :status => :created, :location => @forum }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @forum.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    respond_to do |format|
      if @forum.update_attributes(params[:forum])
        flash[:notice] = 'Forum was successfully updated.'
        format.html { redirect_to(@forum) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @forum.errors, :status => :unprocessable_entity }
      end
    end
  end
 
  def destroy
    @forum.destroy
 
    respond_to do |format|
      format.html { redirect_to(forums_path) }
      format.xml { head :ok }
    end
  end
  
private
  def find_forum
    @forum = Forum.find(params[:id]) if params[:id]
  end
end
