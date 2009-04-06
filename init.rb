require_plugin 'tog_core'
require_plugin 'acts_as_taggable_on_steroids'
require_plugin 'seo_urls'
 
require "i18n" unless defined?(I18n)
Dir[File.dirname(__FILE__) + '/locale/**/*.yml'].each do |file|
  I18n.load_path << file
end

Tog::Plugins.helpers Bookmarks::AddressesHelper

Tog::Interface.sections(:site).add "Bookmarks", "/bookmarks/addresses"     
Tog::Interface.sections(:member).add "Bookmarks", "/member/bookmarks/bookmarks"     
Tog::Interface.sections(:admin).add "Bookmarks", "/admin/bookmarks/addresses"

Tog::Plugins.settings :tog_bookmarks,  'pagination_size' => "10"

Tog::Search.sources << "Address"