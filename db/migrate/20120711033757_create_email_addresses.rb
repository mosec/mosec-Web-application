class CreateEmailAddresses < ActiveRecord::Migration
  def change
    create_table :email_addresses do |t|
      t.belongs_to :contact, null: false
      
      t.string :email_address, null: false
      
      t.timestamps
    end
    
    add_index :email_addresses, :contact_id
    add_index :email_addresses, :email_address
  end
end
