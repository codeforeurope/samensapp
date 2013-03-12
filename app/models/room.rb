class Room < ActiveRecord::Base
  attr_accessible :base_price, :blind_price, :capacity, :floor, :name, :description, :cleaning_fee
		has_many :roomconfigurations
end
