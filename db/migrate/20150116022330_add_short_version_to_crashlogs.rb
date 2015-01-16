class AddShortVersionToCrashlogs < ActiveRecord::Migration
  def change
    add_column :crashlogs, :shortVersion, :string
  end
end
