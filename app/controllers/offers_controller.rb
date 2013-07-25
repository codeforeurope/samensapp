class OffersController < ApplicationController
  before_filter :authenticate_user!, :except => [:new, :create, :by_code]
  before_filter :load_and_authorize
  layout Proc.new { |controller| (controller.request.xhr?) ? 'ajax' : 'application' }
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

  def rooms_for_event
  end

  private
  def load_and_authorize
    @booking_request = BookingRequest.find(params[:booking_request_id])
    @buildings = Building.all            #TODO: load only buildings for current org

    @event = @booking_request.events.build
    @event.event_rooms.build
  end
end
