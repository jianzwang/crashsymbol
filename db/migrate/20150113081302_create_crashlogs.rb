class CreateCrashlogs < ActiveRecord::Migration
  def up
    create_table :crashlogs do |t|
      t.string :name
      t.integer :status
      t.string :incidentId
      t.string :version
      t.string :crashDate
      t.string :osVersion
      t.timestamps null: false
    end
  end

  def down
    drop_table :crashlogs
  end
end
