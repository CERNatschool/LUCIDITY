class AddedFluxspectraProjname < ActiveRecord::Migration
  def self.up
    add_column :flux_spectras, :projectname, :string
  end

  def self.down
    remove_column :flux_spectras, :projectname
  end
end
