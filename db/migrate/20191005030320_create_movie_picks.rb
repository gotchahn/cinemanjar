class CreateMoviePicks < ActiveRecord::Migration[5.2]
  def change
    create_table :movie_picks do |t|
      t.references :account, foreign_key: true
      t.integer :movie_id
      t.text :movie_name
      t.text :movie_poster_url
      t.text :start_time
      t.text :end_time

      t.timestamps
    end
  end
end
