class CreateTextMessages < ActiveRecord::Migration
  def change
    create_table :text_messages do |t|
      t.belongs_to :phone, null: false
      
      t.string :uid, null: false
      t.string :text_message_type, null: false
      t.string :thread_id, null: false
      t.string :phone_number, null: false
      t.string :clean_phone_number, null: false
      t.text :body, null: false
      t.datetime :time, null: false
      
      t.timestamps
    end
    
    add_index :text_messages, :phone_id
    add_index :text_messages, :uid
    add_index :text_messages, :clean_phone_number
  end
end
