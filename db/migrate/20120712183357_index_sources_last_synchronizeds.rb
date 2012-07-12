class IndexSourcesLastSynchronizeds < ActiveRecord::Migration
  def up
  	execute 'CREATE INDEX sources_last_synchronizeds ON sources USING GIN(last_synchronizeds)'
  end

  def down
  	execute 'DROP INDEX sources_last_synchronizeds'
  end
end
