class CreateBookmarks < ActiveRecord::Migration

    def self.up
      create_table :bookmarks do |t|
        t.integer  :address_id
        t.string   :title
        t.string   :description
        t.string   :state
        t.integer  :owner_id
        t.string   :activation_code
        t.string   :owner_type, :default => "", :null =>false
        t.integer  :privacy, :default => 0
        t.timestamps
      end     
      
      create_table :addresses do |t|
        t.string   :url
        t.string   :title, :default => ''
        t.string   :description, :default => ''        
        t.integer  :author_id
        t.integer  :bookmarks_count, :default => 0
        t.timestamps
      end 
              
      
    end

    def self.down
      drop_table :bookmarks
      drop_table :addresses
    end

end
