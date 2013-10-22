class AddedFluxSpectra < ActiveRecord::Migration
  def self.up
    create_table :flux_spectras do |t|
      t.string   :name
      t.text     :filetext
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :flux_spectras
  end
end
