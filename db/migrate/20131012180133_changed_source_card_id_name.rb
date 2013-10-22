class ChangedSourceCardIdName < ActiveRecord::Migration
  def self.up
    add_column :source_cards, :cardid, :string

    remove_index :source_cards, :name => :index_source_cards_on_id rescue ActiveRecord::StatementInvalid
    add_index :source_cards, [:cardid], :unique => true
  end

  def self.down
    remove_column :source_cards, :cardid

    remove_index :source_cards, :name => :index_source_cards_on_cardid rescue ActiveRecord::StatementInvalid
    add_index :source_cards, [:id], :unique => true
  end
end
