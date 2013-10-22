class AddedNeventsToFluxfile < ActiveRecord::Migration
  def self.up
    add_column :flux_spectras, :n_events, :integer, :default => 10000, :null => false
  end

  def self.down
    remove_column :flux_spectras, :n_events
  end
end
