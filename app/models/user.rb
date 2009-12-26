class User < ActiveRecord::Base
  
  has_many :bookmarks, :dependent => :destroy
  
end