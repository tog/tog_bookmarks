class Bookmarks::BookmarksController < ApplicationController

  def user
      @user = User.find(params[:id])
      @page = params[:page] || 1
      @bookmarks = Bookmark.paginate :per_page => Tog::Config['plugins.tog_bookmarks.pagination_size'],
                                     :page => @page, 
                                     :order => 'title',
                                     :conditions => ['state = ? and owner_id = ? and owner_type = ? and privacy = ?', 'active', @user.id, 'User',false]
  end 
  
end