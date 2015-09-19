class FixLightGroupIdColumnName < ActiveRecord::Migration
  def change
    rename_column :lights, :light_object_id, :light_group_id
  end
end
