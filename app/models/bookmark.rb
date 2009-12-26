class Bookmark < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper
  
  acts_as_taggable
  
  attr_accessor :new_bookmark
  
  belongs_to :address, :counter_cache => true
  belongs_to :user
  
  PRIVACY_PRIVATE = 0
  PRIVACY_NETWORK = 1
  PRIVACY_PUBLIC  = 2
  
  named_scope :public,  :conditions => {:privacy => 2}
  named_scope :network, :conditions => ['privacy <> 0']
  
  record_activity_of :user

  #says if the bookmarks is new or it existed and has been updated
  def is_new?
    !self.new_bookmark.nil?
  end
  
  def creation_date(format=:short)
    I18n.l(self.created_at, :format => format)
  end
  
end

