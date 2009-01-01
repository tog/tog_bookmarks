class Admin::Bookmarks::AddressesController < Admin::BaseController 
  
  def index
    @addresses = Address.paginate :per_page => Tog::Config['plugins.tog_bookmarks.pagination_size'],
                                  :page => params[:page], 
                                  :order => 'title'
    
    respond_to do |format|
       format.html # index.html.erb
       format.xml  { render :xml => @addresses }
    end
  end  
  
  def show
      @address = Address.find(params[:id])
  end
  
  def edit
      @address = Address.find(params[:id])
  end  
  
  def update
      @address = Address.find(params[:id])
      @address.update_attributes!(params[:address])
      @address.save
      flash['ok'] = I18n.t("tog_bookmarks.admin.update_address_ok")      
      redirect_to :action => 'show', :id => params[:id]
    rescue ActiveRecord::RecordInvalid
      flash['error'] = I18n.t("tog_bookmarks.admin.update_address_error")
      render :action => 'show', :id => params[:id]  
  end  

  def destroy
    @address = Address.find(params[:id])
    @address.destroy
    redirect_to :action => 'index'
  end
  
end
