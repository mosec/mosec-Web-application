class CreateCalendarEvents < ActiveRecord::Migration
  def change
    create_table :calendar_events do |t|
      t.belongs_to :eventable, polymorphic: true, null: false
      
      t.string :uid, null: false
      t.text :title, null: false
      t.text :description
      t.text :location
      t.string_array :attendee_email_addresses
      t.integer :start_time, null: false
      t.integer :end_time, null: false
      t.boolean :all_day, null: false
      
      t.timestamps
    end
    
    add_index :calendar_events, [:eventable_id, :eventable_type]
    add_index :calendar_events, :uid
  end
end
