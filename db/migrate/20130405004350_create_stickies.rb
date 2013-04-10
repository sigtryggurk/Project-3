class CreateStickies < ActiveRecord::Migration
  def change
    create_table :stickies do |t|
      t.string :text
      t.integer :user_id

      t.timestamps
    end
  end
end
