class CreateLights < ActiveRecord::Migration
  def change
    create_table :lights do |t|
      t.integer :user_id
      t.integer :light_object_id
      t.integer :state
      t.string :label
      t.datetime :expiry

      t.timestamps null: false
    end
  end
end
