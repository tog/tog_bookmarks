require File.dirname(__FILE__) + '/../test_helper'

class BookmarkTest < Test::Unit::TestCase
  context "A Bookmark " do
    
    setup do
      @user1 = Factory(:user, :login => 'chavez')  
      @user2 = Factory(:user, :login => 'evo')  

      @address1 = Factory(:addresses, :url => 'http://www.toghq.com?' + Time.now.to_i.to_s)  
    end
    
    should "count 1 each time a bookmark is created" do
      assert_equal 0, @address1.bookmarks.size,  "Should have 0 bookmarks"
      bookmark = Bookmark.create_bookmark(@address1, @user1)
      assert_equal 1, @address1.bookmarks.size,  "Should have 1 bookmarks"
      bookmark = Bookmark.create_bookmark(@address1, @user2)
      assert_equal 2, @address1.bookmarks.size,  "Should have 2 bookmarks"
    end  
    
    should "not be added twice for a given user" do
      bookmark = Bookmark.create_bookmark(@address1, @user1)
      assert_equal true, bookmark.is_new?,  "Should be a new bookmark"
      bookmark = Bookmark.create_bookmark(@address1, @user1)
      assert_equal false, bookmark.is_new?,  "Shouldn't be a new bookmark"
    end
    
    context "search" do

      setup do        
        @jaiku = Factory(:addresses, :url => 'http://www.jaiku.com', :title => 'jaiku', :description => 'nanoblog')
        @twitter = Factory(:addresses, :url => 'http://www.twitter.com', :title => 'twitter', :description => 'nanoblog')
      end
      
      should_be_restful do |resource|
        resource.create.params = { :title => "test", :description => 'testing params'}
      end


      should "should find one result" do
        params[:title] = 'jaiku'
        params[:description] = 'nanoblog'
        @bookmark1 = Bookmark.create_bookmark(@jaiku, @user, params)
        
        params[:title] = 'twitter'
        params[:description] = 'nanoblog'
        @bookmark2 = Bookmark.create_bookmark(@twitter, @user, params)
        
        assert_contains Bookmark.site_search('jaiku'), @bookmark1
        assert_contains Bookmark.site_search('twitter'), @bookmark2

        @bookmarks = Bookmark.site_search('nanoblog')

        assert_contains @bookmarks, @bookmark1 
        assert_contains @bookmarks, @bookmark2
      end

    end
        
  end
  
end