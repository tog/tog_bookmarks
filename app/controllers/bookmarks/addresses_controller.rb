class Bookmarks::AddressesController < ApplicationController
  include ActionView::Helpers::SanitizeHelper  
  
  def index 
    @order = params[:order] || 'bookmarks_count'
    @page = params[:page] || '1'
    @asc = params[:asc] || 'desc'    
    @addresses = Address.paginate :per_page => Tog::Config['plugins.tog_bookmarks.pagination_size'],
                                  :page => @page,
                                  :order => "#{@order} #{@asc}"
    @asc = @asc == 'asc' ? 'desc' : 'asc' 
    respond_to do |format|
      format.html
      format.rss { render(:layout => false) }
    end                                                   
  end
  
  def show
    @address = Address.find(params[:id])
    
    if logged_in?
      @bookmark = current_user.bookmarks.find_by_address_id(@address.id)
    end 
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @address }
    end
  end


end