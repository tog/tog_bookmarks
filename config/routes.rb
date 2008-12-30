namespace :bookmarks do |bookmark|
  bookmark.resources :addresses, :collection => {:tags => :get}
end

namespace(:member) do |member| 
  member.namespace(:bookmarks) do |bookmark| 
    bookmark.resources :bookmarks, :member => {:copy => :post, :delete=> :get}
    bookmark.user "/bookmarks/user/:profile_id", :controller => "bookmarks", :action => "other_user_index"
    bookmark.share "/bookmarks/share", :controller => "bookmarks", :action => "share_with_group"
  end
end

namespace(:admin) do |admin| 
  admin.namespace(:bookmarks) do |bookmark| 
    bookmark.resources :addresses
  end
end