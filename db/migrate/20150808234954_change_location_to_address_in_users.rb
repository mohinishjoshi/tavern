class ChangeLocationToAddressInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :location, :address
  end
end
