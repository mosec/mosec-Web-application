class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :full_name, null: false
    	t.string :email_address, null: false
    	t.string :password_digest, null: false
    	t.string :context_io_account_id, null: false
      t.string :context_io_web_hook_id, null: false
      t.timestamps
    end

    add_index :users, :email_address
  end
end
