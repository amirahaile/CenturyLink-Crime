class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :code
      t.string :description
      t.integer :longitude
      t.integer :latitude
      t.datetime :time

      t.timestamps null: false
    end
  end
end
