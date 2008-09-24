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

  
end