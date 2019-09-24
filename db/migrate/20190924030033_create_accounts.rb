class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.text :username
      t.text :name
      t.text :email
      t.text :password_digest
      t.text :cinema_id
      t.integer :favorite_genres, array:true, default: []
      t.date :dob
      t.text :favorite_food, array:true, default: []

      t.timestamps
    end
  end
end
