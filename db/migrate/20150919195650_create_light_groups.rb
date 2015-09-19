class CreateLightGroups < ActiveRecord::Migration
  def change
    create_table :light_groups do |t|
      t.integer :owner_id
      t.string :name
      t.text :description
      t.boolean :individual
      t.boolean :listed

      t.timestamps null: false
    end
  end
end
