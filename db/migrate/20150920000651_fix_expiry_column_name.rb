class FixExpiryColumnName < ActiveRecord::Migration
  def change
    rename_column :lights, :expiry, :expires_at
  end
end
