class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.integer :user_id
      t.boolean :active
      t.string :value

      t.timestamps null: false
    end
  end
end
