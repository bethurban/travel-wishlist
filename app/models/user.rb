class User < ActiveRecord::Base
  has_many :wished_places
  has_many :visited_places
  has_secure_password
  validates :username, :presence => true
  validates :email, :presence => true


end
