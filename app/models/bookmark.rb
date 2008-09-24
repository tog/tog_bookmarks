class Bookmark < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper
  
  IS_PUBLIC  = 0
  IS_FRIENDS = 1
  IS_PRIVATE = 2     
  IS_FAMILY = 3
  IS_FAMILY_AND_FRIENDS = 4
    
  acts_as_taggable
  
  attr_accessor :new_bookmark
  
  belongs_to :url, :class_name =>'Address', :foreign_key => 'address_id', :counter_cache => true
  belongs_to :owner, :polymorphic => true, :foreign_key =>'owner_id'
  
  acts_as_state_machine :initial => :pending
  state :pending, :enter => :make_activation_code
  state :active,  :enter => :do_activate
  state :suspended
  state :deleted
  
  event :activate do
    transitions :from => :pending, :to => :active 
  end
  
  event :suspend do
    transitions :from => [:pending, :active], :to => :suspended
  end
  
  event :delete do
    transitions :from => [:pending, :active, :suspended], :to => :deleted
  end

  event :unsuspend do
    transitions :from => :suspended, :to => :active,  :guard => Proc.new {|u| !u.activated_at.blank? }
    transitions :from => :suspended, :to => :pending, :guard => Proc.new {|u| !u.activation_code.blank? }
  end
  
  after_create :make_activation_code
  
  def make_activation_code
    self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end 
  
  def make_activation_code!
    make_activation_code
    self.save!
  end

  def do_activate
    self.activation_code = nil
  end
  
  def is_new?
    !self.new_bookmark.nil?
  end
    
  def authorized(user, permission=:all)
    case permission
    when :read
      authorized_read(user)
    when :write
      authorized_write(user)
    when :destroy
      authorized_destroy(user)
    when :all
      authorized_all(user)
    end
  end
 
  def authorized_read(user)
    case self.privacy
    when IS_PUBLIC
      return true
    when IS_FRIENDS
      return self.owner.profile.friends.include?(user)
    when IS_PRIVATE
      return self.owner == user          
    end         
  end

  def authorized_write(user)
    return self.owner == user
  end

  def authorized_destroy(user)
    return self.owner == user
  end

  def authorized_all(user)
    authorized_read(user) && authorized_write(user) && authorized_destroy(user)
  end  
    
  def share(owner, activate=false)
    newbmk = self.url.add_bookmark(owner, self.title, self.description,  self.tag_list,  self.privacy)
    if (activate)
      newbmk.activate!
    else
      newbmk.make_activation_code!
    end
    return newbmk
  end  
  
  def Bookmark.create_bookmark(addr, owner, title='', description='', tags='', privacy=0)
      bookmark = Bookmark.find(:first,
                        :conditions =>["address_id = ? AND owner_id = ? AND owner_type = ?",addr.id,owner.id,owner.class.name])
      if(bookmark.blank?)
        bookmark = Bookmark.new
        #FIXME privacy not working for bookmarks
        bookmark.url = addr
        bookmark.privacy = privacy
        bookmark.owner = owner
        bookmark.title = title == '' ? addr.title : title
        bookmark.description = description == '' ? addr.description : description
        bookmark.tag_list if tags != ''  
        bookmark.make_activation_code
        bookmark.save  
        bookmark.new_bookmark = true
        addr.bookmarks << bookmark
            
      end
      bookmark
  end  
 
end
