class Bookmarks::AddressesController < ApplicationController
  include ActionView::Helpers::SanitizeHelper  
  
  def index 
    @order = params[:order] || 'bookmarks_count'
    @page = params[:page] || '1'
    @asc = params[:asc] || 'desc'    
    @addresses = Address.paginate :per_page => 10,
                                  :page => @page,
                                  :order => @order + " " + @asc 
    @asc = @asc == 'asc' ? 'desc' : 'asc' 
    respond_to do |format|
      format.html
      format.rss { render(:layout => false) }
    end                                                   
  end
  
  def search #FIXME
    @order = params[:order] || 'links_count'
    @page = params[:page] || '1'
    @search_term = params[:search_term]
    term = '%' + @search_term + '%'
    @asc = params[:asc] || 'asc'    
    @addresses = Address.paginate :per_page => 10,
          :conditions => ["url like ? or title like ? or description like ?", term, term, term],
          :page => @page,
          :order => @order + " " + @asc 
    @asc = @asc == 'asc' ? 'desc' : 'asc'            
    respond_to do |format|
       format.html { render :template => "ilinks/addresses/index"}
       format.xml  { render :xml => @addresses }
    end
  end  
  
  def listcommunitylinks #FIXME
    @community = Community.find(params[:community_id])
    @per_page = nil
    petition_type = @url.instance_variable_get(:@parameters)['format']
    if(petition_type != 'rss')
      @per_page = 5
    end
    @links,@num_links = Link.search_by_community(params[:community_id], params[:pagelinks], @per_page, current_user)
    @pagelinks = params[:pagelinks] || 1
    if(@per_page != nil)
      @max_page_links = @num_links.to_f/@per_page
    end
    @selectedlink = nil
    @comments = nil
    @showcomments = false
    if(params[:link_id] != nil)
      @selectedlink = Link.find(params[:link_id])
      if(params[:load_comments])
        @showcomments = true
        offset = (params[:pagecomments].to_i * @per_page) - @per_page
        if(offset < 0)
          offset = 0
        end
        @comments = Comment.find(:all,:conditions =>["commentable_id = ? AND commentable_type = ?",@selectedlink.url.id,"Address"],:offset =>offset,:limit=>@per_page)
        @pagecomments = params[:pagecomments] || 1
        @num_comments = @selectedlink.url.comments.size
        @max_page_comments = @num_comments.to_f/@per_page
      end
    end
    
    respond_to do |format|
      format.html #listlinks.html.erb
      format.rss  { render :rss => [@links,@community] }
    end
  end
  
  def sendlink #FIXME
    @link = Link.find(params[:link_id])
    
    LinkMailer.deliver(LinkMailer.create_send_link(@link,current_user,params[:email]))
    
    render :update do |page|
      page.hide "sendLinkDiv"
      page.form.reset "sendLinkForm"
    end
  end
  
  # GET /links/1
  # GET /links/1.xml
  def show
    @address = Address.find(params[:id])
    
    if logged_in?
      @bookmark = Bookmark.find(:first,
                                :conditions =>["address_id = ? AND owner_id = ? AND owner_type = ?",
                                                @address.id,current_user.id,"User"])
    end 
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @address }
    end
  end
  
  def lastlinks
    @addresses = Address.find(:all, :limit => 10, :order => 'publish_date desc')
    render :layout =>  false 
  end  
  
  def toplinks
    @addresses = Address.find(:all, :limit => 10, :order => 'links_count desc')
    render :layout =>  false 
  end  
  
end