class AddedSourceCards < ActiveRecord::Migration
  def self.up
    create_table :source_cards do |t|
      t.string   :id
      t.integer  :n_events
      t.string   :particle_type
      t.decimal  :e_min, :precision => 30, :scale => 15
      t.decimal  :e_max, :precision => 30, :scale => 15
      t.decimal  :flux_integral, :precision => 30, :scale => 15
      t.decimal  :flux_differential, :precision => 30, :scale => 15
      t.text     :notes
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :flux_spectra_id
    end
    add_index :source_cards, [:id], :unique => true
    add_index :source_cards, [:flux_spectra_id]

    add_column :flux_spectras, :source_cards_count, :integer, :default => 0, :null => false

    add_index :flux_spectras, [:name], :unique => true
  end

  def self.down
    remove_column :flux_spectras, :source_cards_count

    drop_table :source_cards

    remove_index :flux_spectras, :name => :index_flux_spectras_on_name rescue ActiveRecord::StatementInvalid
  end
end
