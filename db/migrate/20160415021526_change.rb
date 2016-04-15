class Change < ActiveRecord::Migration
  def change
    rename_column :events, :code, :zone
    add_column :events, :group, :string
  end
end
