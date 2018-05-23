class FixPlacesBeenColumnType < ActiveRecord::Migration
  def change
    change_column :visited_places, :date_traveled, :string
  end
end
