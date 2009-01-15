class ForumsController < ApplicationController

  # GET /forums
  # GET /forums.xml
  def index
    @order = params[:order] || 'tog_forum_forums.title' 

    @page = params[:page] || '1'
    @asc = (params[:asc] and params[:asc] == "desc") ? "asc" : 'desc'

    @forums = TogForum::Forum.paginate :per_page => Tog::Config["plugins.tog_forum.forums.list.page.size"],
                                       :page => @page,
                                       :order => @order + " " + @asc

      
      respond_to do |format|
        format.html
        format.rss { render :rss => @forums }
      end
  end
  
  # GET /forums/1
  # GET /forums/1.xml
  def show
    @forum = TogForum::Forum.find_by_id(params[:id]) || TogForum::Forum.top_level
    
    @order = params[:order] || 'tog_forum_topics.title' #'tog_forum_topics.current_rating'

    @page = params[:page] || '1'
    @asc = (params[:asc] and params[:asc] == "desc") ? "asc" : 'desc'

    @forum = TogForum::Forum.top_level
    @topics = TogForum::Topic.paginate :per_page => Tog::Config["plugins.tog_forum.topics.list.page.size"],
                                       :page => @page,
                                       :conditions => ['tog_forum_topics.forum_id = ?', @forum.id],
                                       :order => @order + " " + @asc
    
    respond_to do |format|
      format.js { render :partial => "/forums/partials/topics_paginated" }
      format.html
      format.rss { render :rss => @forum }
    end
  end

end
