class AddedCardfileToSourcecards < ActiveRecord::Migration
  def self.up
    add_column :source_cards, :cardfile_file_name, :string
    add_column :source_cards, :cardfile_content_type, :string
    add_column :source_cards, :cardfile_file_size, :integer
    add_column :source_cards, :cardfile_updated_at, :datetime
  end

  def self.down
    remove_column :source_cards, :cardfile_file_name
    remove_column :source_cards, :cardfile_content_type
    remove_column :source_cards, :cardfile_file_size
    remove_column :source_cards, :cardfile_updated_at
  end
end
