plugin 'tog_bookamrs', :git => "git://github.com/tog/tog_bookmarks.git"

route "map.routes_from_plugin 'tog_bookmarks'"

generate "update_tog_migration"

rake "db:migrate"
