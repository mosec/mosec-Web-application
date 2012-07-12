class AddLastSynchronizedsToSources < ActiveRecord::Migration
  def change
    add_column :sources, :last_synchronizeds, :hstore
  end
end
