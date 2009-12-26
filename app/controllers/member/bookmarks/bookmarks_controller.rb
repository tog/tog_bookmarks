class Member::Bookmarks::BookmarksController < Member::BaseController 
  
  include ActionView::Helpers::SanitizeHelper
            
  def index
    @page = params[:page] || 1
    @bookmarks = current_user.bookmarks.paginate :per_page => Tog::Config['plugins.tog_bookmarks.pagination_size'],
                                                 :page => @page
                                   
  end
  
  def copy
    address = Address.find(params[:id])
    @bookmark = address.add_bookmark(current_user)
  
    flash[:ok] = @bookmark.is_new? ? flash = I18n.t("tog_bookmarks.member.bookmark_copy") : I18n.t("tog_bookmarks.member.bookmark_not_copy")

    redirect_to :back
  end

  def new
  end
  
  def create 
    @address = Address.get_address(params[:bookmark][:url], 
                                   current_user,
                                   params[:bookmark][:title], 
                                   params[:bookmark][:description])   
       
    @bookmark = @address.add_bookmark(current_user, 
                                      params[:bookmark][:privacy],
                                      params[:bookmark][:title], 
                                      params[:bookmark][:description], 
                                      params[:bookmark][:tag_list])                                      
                                      
                                        
    respond_to do |format|
      if @bookmark.save
        flash[:ok] = I18n.t("tog_bookmarks.member.bookmark_created") 
        format.html { redirect_to :action => 'index'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bookmark.errors, :status => :unprocessable_entity }
      end
    end
  end    

  def edit
    @bookmark = current_user.bookmarks.find(params[:id])
  end
  
  def update
    bookmark = current_user.bookmarks.find(params[:id])
    if bookmark.update_attributes(params[:bookmark])
      respond_to do |format|
        format.html { redirect_to :action => 'index' }
        format.xml  { head :ok }
      end
    end
  end
  
  def destroy
    bookmark = current_user.bookmarks.find(params[:id])
    bookmark.destroy
    respond_to do |format|
      format.html { redirect_to :action => 'index' }
      format.xml  { head :ok }
    end
  end     
 
end
