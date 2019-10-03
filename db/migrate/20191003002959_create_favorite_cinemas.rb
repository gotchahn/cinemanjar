class CreateFavoriteCinemas < ActiveRecord::Migration[5.2]
  def change
    create_table :favorite_cinemas do |t|
      t.integer :movie_glu_cinema_id
      t.text :name
      t.text :address
      t.text :logo_url

      t.timestamps
    end
    # remove old cinema id
    remove_column :accounts, :cinema_id
    # Add reference now
    add_reference :accounts, :favorite_cinema, index: true
  end
end
