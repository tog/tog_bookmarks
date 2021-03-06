namespace :bookmarks do |bookmark|
  bookmark.resources :addresses, :collection => {:tag => :get}
end

with_options(:controller => 'bookmarks/bookmarks') do |bookmarks|
  bookmarks.bookmarks_for_user   '/bookmarks/user/:id', :action => 'user'
end

namespace(:member) do |member| 
  member.namespace(:bookmarks) do |bookmark| 
    bookmark.resources :bookmarks, :member => {:copy => :post}
  end
end

namespace(:admin) do |admin| 
  admin.namespace(:bookmarks) do |bookmark| 
    bookmark.resources :addresses
  end
end