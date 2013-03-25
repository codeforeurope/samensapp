class Room < ActiveRecord::Base
  attr_accessible :base_price, :blind_price, :capacity, :floor, :name, :description, :cleaning_fee, :pictures_attributes, :building_id, :notes
  belongs_to :building
  has_many :pictures, as: :attachable_picture, :dependent => :destroy

  #accepts_nested_attributes_for :pictures
end
