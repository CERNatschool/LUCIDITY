class AddedSourcecardszipToFluxfile < ActiveRecord::Migration
  def self.up
    add_column :flux_spectras, :sourcecardsfile_file_name, :string
    add_column :flux_spectras, :sourcecardsfile_content_type, :string
    add_column :flux_spectras, :sourcecardsfile_file_size, :integer
    add_column :flux_spectras, :sourcecardsfile_updated_at, :datetime
  end

  def self.down
    remove_column :flux_spectras, :sourcecardsfile_file_name
    remove_column :flux_spectras, :sourcecardsfile_content_type
    remove_column :flux_spectras, :sourcecardsfile_file_size
    remove_column :flux_spectras, :sourcecardsfile_updated_at
  end
end
