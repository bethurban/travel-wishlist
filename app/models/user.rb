class User < ActiveRecord::Base
  has_many :places_wished
  has_many :places_been
  has_secure_password
  validates :username, :presence => true
  validates :email, :presence => true


end
