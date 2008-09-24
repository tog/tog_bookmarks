class Address < ActiveRecord::Base
  acts_as_commentable
  acts_as_abusable  

  belongs_to :owner, :class_name =>'User', :foreign_key =>'author_id'
  has_many :bookmarks, :class_name =>'Bookmark', :foreign_key =>'address_id', :dependent => :destroy

  before_save :normalize_url 
  
  def normalize_url
    if self.url[0..."http".length] != "http"
      self.url = "http://" + self.url
    end
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
    
end
