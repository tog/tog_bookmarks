namespace :bookmarks do |bookmark|
  bookmark.resources :addresses
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