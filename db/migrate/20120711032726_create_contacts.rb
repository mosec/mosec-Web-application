class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.belongs_to :contactable, polymorphic: true, null: false
      
      t.string :uid, null: false
      t.string :full_name, null: false

      t.timestamps
    end
    
    add_index :contacts, [:contactable_id, :contactable_type]
    add_index :contacts, :uid
  end
end
