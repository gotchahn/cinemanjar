class CreateFoodPicks < ActiveRecord::Migration[5.2]
  def change
    create_table :food_picks do |t|
      t.references :account, foreign_key: true
      t.integer :restaurant_id
      t.text :restaurant_name
      t.text :restaurant_image_url
      t.text :cuisines

      t.timestamps
    end
  end
end
