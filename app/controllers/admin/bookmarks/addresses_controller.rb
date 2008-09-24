class Admin::Bookmarks::AddressesController < Admin::BaseController 
  
  def index
    @addresses = Address.paginate :per_page => 20,
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
  
  def update
      @address = Address.find(params[:id])
      @address.update_attributes!(params[:address])
      @address.save
      flash['ok'] = "Updated successfully"      
      redirect_to :action => 'show', :id => params[:id]
    rescue ActiveRecord::RecordInvalid
      flash['error'] = "Problem updating address"
      render :action => 'show', :id => params[:id]  
  end  

  def destroy
    @address = Address.find(params[:id])
    @address.destroy
    redirect_to :action => 'index'
  end
  
end
