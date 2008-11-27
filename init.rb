require_plugin 'tog_core'
require_plugin 'acts_as_taggable_on_steroids'
require_plugin 'seo_urls'
 
Dir[File.dirname(__FILE__) + '/locale/**/*.yml'].each do |file|
  I18n.load_translations file
end

Tog::Plugins.helpers Bookmarks::AddressesHelper

Tog::Interface.sections(:site).add "Links", "/bookmarks/addresses"     
Tog::Interface.sections(:member).add "Links", "/member/bookmarks/bookmarks"     
Tog::Interface.sections(:admin).add "Links", "/admin/bookmarks/addresses"

Tog::Plugins.settings :tog_bookmarks,  'pagination_size' => "10"     

