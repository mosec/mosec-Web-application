class CreateCalls < ActiveRecord::Migration
  def change
    create_table :calls do |t|
      t.belongs_to :phone, null: false
      
      t.string :uid, null: false
      t.string :call_type, null: false
      t.string :phone_number, null: false
      t.string :clean_phone_number, null: false
      t.integer :duration, null: false
      t.datetime :time, null: false
      
      t.timestamps
    end
    
    add_index :calls, :phone_id
    add_index :calls, :uid
    add_index :calls, :clean_phone_number
  end
end
