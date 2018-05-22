class CreatePlacesBeen < ActiveRecord::Migration[5.2]
  def change
    create_table :places_been do |t|
      t.string :destination
      t.datetime :date_traveled
      t.string :travel_partner
      t.string :notes
      t.integer :user_id
    end
  end
end
