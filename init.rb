require_plugin 'tog_core'
require_plugin 'acts_as_taggable_on_steroids'
require_plugin 'seo_urls'

Tog::Plugins.helpers Bookmarks::AddressesHelper

Tog::Interface.sections(:admin).add "Links", "/admin/bookmarks/addresses"     

