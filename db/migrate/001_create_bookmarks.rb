class CreateBookmarks < ActiveRecord::Migration

    def self.up
      create_table :bookmarks do |t|
        t.integer  :address_id
        t.string   :title
        t.string   :description
        t.integer  :user_id
        t.integer  :privacy, :default => 0
        t.timestamps
      end     
      
      create_table :addresses do |t|
        t.string   :url
        t.string   :title, :default => ''
        t.string   :description, :default => ''        
        t.integer  :user_id
        t.integer  :bookmarks_count, :default => 0
        t.timestamps
      end 
              
      
    end

    def self.down
      drop_table :bookmarks
      drop_table :addresses
    end

end
