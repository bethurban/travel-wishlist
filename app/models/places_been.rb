class PlacesBeen < ActiveRecord::Base
  belongs_to :user
  validates :destination, :presence => true

end