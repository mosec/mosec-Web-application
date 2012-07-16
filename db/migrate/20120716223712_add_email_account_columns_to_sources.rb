class AddEmailAccountColumnsToSources < ActiveRecord::Migration
  def change
  	change_table :sources do |t|
  		t.string :email_address
  		t.string :access_token
  		t.string :access_secret
  		t.string :context_io_source_label
  	end
  end
end
