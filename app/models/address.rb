require 'uri'

class Address < ActiveRecord::Base
  acts_as_commentable
  acts_as_abusable  
  acts_as_rateable :average => true  

  belongs_to :user
  has_many :bookmarks, :dependent => :destroy

  before_save :normalize_url
  before_save :get_host 
  
  def self.site_search(query, search_options={})
    sql = "%#{query}%"
    Address.find(:all, :conditions => ["title like ? or description like ? or url like ?", sql, sql, sql])
  end
    
  def normalize_url
    if self.url[0..."http".length] != "http"
      self.url = "http://" + self.url
    end
  end  
  
  def add_bookmark(user, privacy=Bookmark::PRIVACY_PRIVATE, title='', description='', tag_list=nil)
    bookmark = user.bookmarks.find_by_address_id(self.id)
    unless bookmark
      bookmark = Bookmark.new
      #this bookmark didn't exist previously
      bookmark.new_bookmark = true
    end
    bookmark.address = self
    bookmark.user = user
    bookmark.privacy = privacy
    bookmark.title = title == '' ? self.title : title
    bookmark.description = description == '' ? self.description : description
    bookmark.tag_list = tag_list
    bookmark.save  
    self.bookmarks << bookmark
    bookmark
  end  
  
  def creation_date(format=:short)
    I18n.l(created_at, :format => format)
  end  
  
  def Address.get_address(url, user, title='', description='')
    url = url[0..url.size-2] if url.rindex('/') == url.size - 1
    addr = Address.find(:first,:conditions =>["url = ?",url])
    if(addr.blank?)
      addr = Address.new(:url=> url,
                         :user => user,
                         :title => title,
                         :description => description)
      addr.save
    else
      title = addr.title if title == ''
      description = addr.description if description == ''
      addr.save      
    end
    addr
  end
  
  protected
  
    def get_host
      self.host = URI.parse(self.url).host
    end
  
end
