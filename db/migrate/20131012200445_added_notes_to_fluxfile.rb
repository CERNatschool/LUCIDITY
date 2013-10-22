class AddedNotesToFluxfile < ActiveRecord::Migration
  def self.up
    add_column :flux_spectras, :notes, :text
  end

  def self.down
    remove_column :flux_spectras, :notes
  end
end
