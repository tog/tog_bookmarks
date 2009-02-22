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
  
  def tag_cloud_bookmarks(classes)
    tags = Bookmark.tag_counts
    return if tags.empty?
    max_count = tags.sort_by(&:count).last.count.to_f
    tags.each do |tag|
      index = ((tag.count / max_count) * (classes.size - 1)).round
      yield tag, classes[index]
    end
  end
  
  def snapshot_image(address, size=150)
    image_tag "http://api.thumbalizr.com/?url=#{address.url}&width=#{size}"
  end
end