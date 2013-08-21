class EventCharge < ActiveRecord::Base
  belongs_to :event
  attr_accessible :name, :price, :units
  attr_writer :total
  validates_presence_of :name, :price, :units

  def total
    @total ||= price * units
  end
end
