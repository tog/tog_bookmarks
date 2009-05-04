require 'uri'

class Address < ActiveRecord::Base
  acts_as_commentable
  acts_as_abusable  
  acts_as_rateable :average => true  

  belongs_to :owner, :class_name =>'User', :foreign_key =>'author_id'
  has_many :bookmarks, :class_name =>'Bookmark', :foreign_key =>'address_id', :dependent => :destroy

  before_save :normalize_url
  before_save :get_host 
  
  def normalize_url
    if self.url[0..."http".length] != "http"
      self.url = "http://" + self.url
    end
  end  
  
  def add_bookmark(owner, title='', description='', tag_list=nil, privacy=0)
      bookmark = Bookmark.find(:first,
                        :conditions =>["address_id = ? AND owner_id = ? AND owner_type = ?",self.id,owner.id,owner.class.name])
      if(bookmark.blank?)
        bookmark = Bookmark.new
        bookmark.new_bookmark = true
      end
      bookmark.url = self
      bookmark.owner = owner
      bookmark.privacy = privacy
      bookmark.title = title == '' ? self.title : title
      bookmark.description = description == '' ? self.description : description
      bookmark.tag_list = tag_list
      bookmark.make_activation_code
      bookmark.save  
      self.bookmarks << bookmark
      bookmark
  end  
  
  def Address.get_address(url, user, title='', description='')
    url = url[0..url.size-2] if url.rindex('/') == url.size - 1
    addr = Address.find(:first,:conditions =>["url = ?",url])
    if(addr.blank?)
      addr = Address.new(:url=> url,
                        :owner => user,
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
