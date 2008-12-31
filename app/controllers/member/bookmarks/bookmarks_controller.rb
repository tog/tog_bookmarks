class Member::Bookmarks::BookmarksController < Member::BaseController 
  
  include ActionView::Helpers::SanitizeHelper
        
  before_filter :check_owner, :only => [:delete]   
    
  def index
    @page = params[:page] || 1
    @bookmarks = Bookmark.paginate :per_page => Tog::Config['plugins.tog_bookmarks.pagination_size'],
                                   :page => @page, 
                                   :order => 'title',
                                   :conditions => ['state = ? and owner_id = ? and owner_type = ?', 'active', current_user.id, 'User']
                                   
  end
  
  def copy
    address = Address.find(params[:id])
    @bookmark = address.add_bookmark(current_user, 
                                     params[:title], 
                                     params[:description], 
                                     params[:tag_list], 
                                     params[:privacy])
  
    if @bookmark.is_new?
      msg = I18n.t("tog_bookmarks.member.bookmark_copy")
      @bookmark.activate!		
    else
      msg = I18n.t("tog_bookmarks.member.bookmark_not_copy")     
    end   
    render :update do |page|		
	    page.replace_html 'msg'+params[:id] , msg
	    page.visual_effect(:appear, 'feedback'+params[:id], :duration => 0.5)
    end
  end

  def create 
    @address = Address.get_address(params[:bookmark][:url], 
                                   current_user,
                                   params[:bookmark][:title], 
                                   params[:bookmark][:description])   
       
    @bookmark = @address.add_bookmark(current_user, 
                                      params[:bookmark][:title], 
                                      params[:bookmark][:description], 
                                      params[:bookmark][:tag_list], 
                                      params[:bookmark][:privacy])                                      
                                      
                                        
    respond_to do |format|
        if @bookmark.save
            flash[:ok] = I18n.t("tog_bookmarks.member.bookmark_created") 
            @bookmark.activate!
            format.html { redirect_to :action => 'index'}
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @bookmark.errors, :status => :unprocessable_entity }
        end
    end
  end    

  def update
    @bookmark = Bookmark.find(params[:id])
    if @bookmark.authorized_write(current_user)
      @bookmark.update_attributes(params[:bookmark])
      respond_to do |format|
        format.html { redirect_to :back }
        format.xml  { head :ok }
      end
    end
  end
  
  def delete
    @bookmark.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.xml  { head :ok }
    end
  end     
  
  private 
    def check_owner
      @bookmark = Bookmark.find(params[:id])
      if(!@bookmark.authorized_destroy(current_user))
        redirect_to login_path
      end
    end
  	    
end
