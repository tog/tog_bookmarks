module Bookmarks::AddressesHelper

  def top_addresses(limit=5)
    Address.find(:all, :limit => limit, :order => 'bookmarks_count desc')
  end
  
  def addresses_count
    Address.count
  end
  
  def last_addresses(limit=5)
    Address.find(:all, :limit => limit, :order => 'created_at desc')
  end

end