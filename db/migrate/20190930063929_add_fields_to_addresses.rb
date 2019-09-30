class AddFieldsToAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :latitude, :decimal
    add_column :addresses, :longitude, :decimal
  end
end
