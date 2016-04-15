class RenameEventTimeToDatetime < ActiveRecord::Migration
  def change
    rename_column :events, :time, :datetime
  end
end
