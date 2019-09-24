class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.text :street
      t.text :apt_number
      t.text :city
      t.text :state
      t.text :postal_code
      t.references :account, foreign_key: true

      t.timestamps
    end
  end
end
