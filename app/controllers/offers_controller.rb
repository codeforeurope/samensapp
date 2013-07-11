class OffersController < ApplicationController
  before_filter :authenticate_user!, :except => [:new, :create, :by_code]
  before_filter :load_and_authorize
  def new

  end

  def edit
  end

  def show
  end

  def create
  end

  def update
  end

  def accept
  end

  def decline
  end

  def invalidate
  end


  private
  def load_and_authorize
    @booking_request = BookingRequest.find(params[:booking_request_id])
    @buildings = Building.all

    @event = @booking_request.events.build
  end
end
