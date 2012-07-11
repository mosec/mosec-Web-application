class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
    	t.belongs_to :user, null: false

    	# For STI
    	t.string :type, null: false

    	t.string :provider, null: false
    	t.string :uid, null: false

      t.timestamps
    end

    add_index :sources, :type
    add_index :sources, [:uid, :provider]
  end
end
