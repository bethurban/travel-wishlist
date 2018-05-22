class CreatePlacesWished < ActiveRecord::Migration[5.2]
  def change
    create_table :places_wished do |t|
      t.string :destination
      t.datetime :travel_by
      t.string :travel_partner
      t.string :notes
      t.timestamps
      t.integer :user_id
    end
  end
end
