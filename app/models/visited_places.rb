class VisitedPlace < ActiveRecord::Base
  belongs_to :user
  validates :destination, :presence => true
  validates :date_traveled, :presence => true

end
