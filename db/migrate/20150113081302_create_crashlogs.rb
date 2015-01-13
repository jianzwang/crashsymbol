class CreateCrashlogs < ActiveRecord::Migration
  def change
    create_table :crashlogs do |t|
      t.text :name
      t.integer :status
      t.timestamps null: false
    end
  end
end
