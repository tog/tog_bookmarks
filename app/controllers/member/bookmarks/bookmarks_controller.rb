class Member::Bookmarks::BookmarksController < Member::BaseController 
  
  include ActionView::Helpers::SanitizeHelper
        
    before_filter :check_owner, :only => [:delete,:update]   
      
    def index
      @page = params[:page] || 1
      @bookmarks = Bookmark.paginate :per_page => 10,
                                     :page => @page, 
                                     :order => 'title',
                                     :conditions => ['state = ? and owner_id = ? and owner_type = ?', 'active', current_user.id, 'User']
    end
    
    def copy
      address = Address.find(params[:id])
      @bookmark = Bookmark.create_bookmark(address, current_user)
    
      if @bookmark.is_new?
        msg = 'Bookmark created'
        @bookmark.activate!		
      else
        msg = 'You already have this bookmark in your profile'     
      end   
      render :update do |page|		
		    page.replace_html 'msg'+params[:id] , msg
		    page.visual_effect(:appear, 'feedback'+params[:id], :duration => 0.5)
	    end
    end
        
    def shareaddon #FIXME
      url =  params[:origin]
      @address = address = Address.find(params[:id])


      #TODO volver a activar esto
      #      if(@user.family)
      #          @related = @user.family.users.find(:all,:conditions => ["users.id != ?",@user.id])
      #      end
      #      @communities = @user.communities
      render  :layout => "addon"  
    end    
    
    def drop_link #FIXME
      @link = Link.find(params[:id].slice(6..params[:id].length-1))
      if (not params[:related_id].blank?)
        @link.share_with_user(User.find(params[:related_id]))
        render :update do |page|
          page.visual_effect :highlight, "related_#{params[:related_id]}", :duration => 2 
          page.visual_effect(:appear, 'feedback_msg', :duration => 0.5)
        end
      elsif (not params[:community_id].blank?)
        @group = Group.find(params[:community_id])
        share_with_community if @group
        render :update do |page|
           page.visual_effect :highlight, "community_#{params[:community_id]}", :duration => 2
           page.visual_effect(:appear, 'feedback_msg', :duration => 0.5) 
        end
      else
        @family = Family.find(params[:family_id])
        share_with_family if @family
        render :update do |page|
          page.visual_effect :highlight, "family_#{params[:family_id]}", :duration => 2 
          page.visual_effect(:appear, 'feedback_msg', :duration => 0.5)
        end
      end
    end
        
    def drop_link_addon  #FIXME
      @address = Address.get_address(
                 params[:bookmark][:url], 
                 current_user,
                 params[:bookmark][:title], 
                 params[:bookmark][:description])   
                 
     @bookmark = Bookmark.create_bookmark(@address, current_user,
                                       params[:bookmark][:title], 
                                       params[:bookmark][:description],
                                       params[:bookmark][:tag_list], 
                                       params[:bookmark][:privacy])     

      if (not params[:family].blank?)
        @family = Family.find(params[:family])
        share_with_family if @family
      end
      if (not params[:community].blank?)
        params[:community].each do |cid|
          @group = Group.find(cid)
          share_with_community if @group      
        end
      end
      if (not params[:users].blank?)
        params[:users].each do |uid|      
          @link.share_with_user(User.find(uid))  
        end    
      end    
    end    
    
    def create 
      @address = Address.get_address(
                 params[:bookmark][:url], 
                 current_user,
                 params[:bookmark][:title], 
                 params[:bookmark][:description])   
      @bookmark = Bookmark.create_bookmark(@address, current_user,
                                        params[:bookmark][:title], 
                                        params[:bookmark][:description],
                                        params[:bookmark][:tag_list], 
                                        params[:bookmark][:privacy])                                  

      #TODO volver a activar esto
      #@link.visibility = Visibility.find(:first,:conditions =>{:id,params[:visibility].to_i})

      respond_to do |format|
          if @bookmark.save
              flash[:ok] = 'Bookmark successfully created.'
              @bookmark.activate!
              format.html { redirect_to :action => 'index'}
          else
            format.html { render :action => "new" }
            format.xml  { render :xml => @@bookmark.errors, :status => :unprocessable_entity }
          end
      end
    end    

    def update #FIXME
      
      if @bookmark.authorized_write(user)

      end
            
      @link.url.url = sanitize(params[:url])
      @link.replace_tags(params[:tags])
      @link.update_attributes(params[:link])
      if @link.owner_type == 'User'
        redirect_to  '/ilinks/user/' + @link.owner_id.to_s
      end
      if @link.owner_type == 'Group'
        redirect_to  '/ilinks/community/' + @link.owner_id.to_s
      end      
      if @link.owner_type == 'Family'
        redirect_to  '/ilinks/family'
      end
    end
    
    def delete #FIXME

      if @bookmark.authorized_destroy(user)
        @bookmark.destroy
      end

      respond_to do |format|
        format.html { redirect_to :action => :index }
        format.xml  { head :ok }
      end
    end     
    
  	    
end
