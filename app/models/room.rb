class Room < ActiveRecord::Base
  attr_accessible :base_price, :blind_price, :capacity, :floor, :name, :description, :cleaning_fee, :pictures_attributes
  belongs_to :building
  has_many :pictures, as: :attachable_picture

  accepts_nested_attributes_for :pictures
end
