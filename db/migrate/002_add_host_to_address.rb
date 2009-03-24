class AddHostToAddress < ActiveRecord::Migration
  def self.up
    add_column :addresses, :host, :string
    
    Address.find(:all).each do |addr|
      addr.save  #update address with before_save filter
    end
  end

  def self.down
    remove_column :addresses, :host
  end
end
