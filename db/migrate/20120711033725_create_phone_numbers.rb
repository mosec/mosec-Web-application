class CreatePhoneNumbers < ActiveRecord::Migration
  def change
    create_table :phone_numbers do |t|
      t.belongs_to :contact, null: false
      
      t.string :phone_number, null: false
      t.string :clean_phone_number, null: false
      
      t.timestamps
    end
    
    add_index :phone_numbers, :contact_id
    add_index :phone_numbers, :clean_phone_number
  end
end
