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
      @forum = TogForum::Forum.top_level
      @topics = @forum.topics.paginate(:all, {:order => "current_rating DESC", :page => options[:page] || 1, :per_page => options[:per_page] || 10}) rescue []
      
      render :action => "show"
    end
  end
  
  def index_for_admin
    @page = params[:page] || '1'
    @forums = TogForum::Forum.all.paginate({:page => @page})
    respond_to do |format|
      format.html
      format.rss { render :rss => @forums }    
    end
  end

  # GET /forums/1
  # GET /forums/1.xml
  def show
    @order = params[:order] || 'tog_forum_topics.current_rating'

    @page = params[:page] || '1'
    @asc = (params[:asc] and params[:asc] == "desc") ? "asc" : 'desc'

    @forum = TogForum::Forum.top_level
    @topics = TogForum::Topic.paginate :per_page => Tog::Config["plugins.tog_social.profile.list.page.size"],
                                       :page => @page,
                                       :conditions => ['tog_forum_topics.forum_id = ?', @forum.id],
                                       :order => @order + " " + @asc
    
    respond_to do |format|
      format.js { render :partial => "/forums/partials/topics_paginated" }
      format.html
      format.rss { render :rss => @forum }
    end
  end

  # GET /forums/new
  # GET /forums/new.xml
  def new
    @forum = TogForum::Forum.new

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
    @forum = TogForum::Forum.new(params[:forum])
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
    @forum = TogForum::Forum.find(params[:id])

    if @forum.destroy
      flash[:notice] = "The forum was successfully deleted."
    else
      flash[:error] = "An error occurred: #{@forum.errors.full_messages}"
    end
    
    respond_to do |format|
      format.html { redirect_to(forums_url) }
      format.xml  { head :ok }
    end
  end

private
  def find_forum
    @forum = TogForum::Forum.find_by_id(params[:id]) || TogForum::Forum.top_level
    if @forum.blank? and Tog::Config["plugins.tog_forum.ensure_top_level"]
      @forum = TogForum::Forum.create_top_level
    end
  end
end
