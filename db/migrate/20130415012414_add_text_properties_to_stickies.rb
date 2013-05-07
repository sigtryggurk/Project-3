class AddTextPropertiesToStickies < ActiveRecord::Migration
  def change
    add_column :stickies, :textProperties, :string
  end
end
