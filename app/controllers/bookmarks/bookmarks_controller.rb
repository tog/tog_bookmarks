class Bookmarks::BookmarksController < ApplicationController

  def user
      @user = User.find(params[:id])
      @order = params[:order] || 'created_at'
      @page = params[:page] || 1
      @asc = params[:asc] || 'desc'   
      if logged_in? && current_user == @user
        @bookmarks = @user.bookmarks.all(:order => "#{@order} #{@asc}")
      elsif logged_in? && current_user.profile.is_friend_of?(@user.profile)
        @bookmarks = @user.bookmarks.network(:order => "#{@order} #{@asc}")
      else
        @bookmarks = @user.bookmarks.public(:order => "#{@order} #{@asc}")
      end  
      @bookmarks = @bookmarks.paginate :per_page => Tog::Config['plugins.tog_bookmarks.pagination_size'],
                                       :page => @page
                                       
      @asc = @asc == 'asc' ? 'desc' : 'asc' 
  end 
  
end