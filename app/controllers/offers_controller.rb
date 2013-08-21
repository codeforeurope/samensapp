class OffersController < InheritedResources::Base
  before_filter :authenticate_user!, :except => [:by_code, :accept, :decline]
  before_filter :load_available_buildings
  load_and_authorize_resource :booking_request, :through => :event
  load_and_authorize_resource :event
  defaults :resource_class => 'Event', :singleton => true, :instance_name => :event
  optional_belongs_to :booking_request

  layout Proc.new { |controller| (controller.request.xhr?) ? 'ajax' : 'application' }
  before_filter :resource, :only => [:accept, :decline, :cancel]


  def by_code

    @event = Event.find_all_by_code(params[:code]).first
    @booking_request = @event.booking_request

    render :action => :show

  end

  def accept
    authorize! :accept, @event, params
    @event.status = :accepted
    update! do |format|
      format.html {
        redirect_to signed_in? ? booking_request_offer_url(@booking_request) : view_offer_url(@event.code)
      }
    end
  end

  def decline
    authorize! :decline, @event, params
    @event.status = :declined
    update! do |format|
      format.html {
        redirect_to signed_in? ? booking_request_offer_url(@booking_request) : view_offer_url(@event.code)
      }
    end
  end

  def cancel
    authorize! :cancel, @event, params
    @event.status = :canceled
    update! do |format|
      format.html {
        redirect_to signed_in? ? booking_request_offer_url(@booking_request) : view_offer_url(@event.code)
      }
    end
  end

  def send_offer

  end

  def ical
  end

  def rooms_for_event
    render layout: false
  end

  protected


  def resource
    if @event.blank?
      @event = @booking_request.event
      @event.event_rooms.each do |event_room|
        event_room.available_rooms = Room.where :building_id => event_room.building_id if event_room.building_id.present?
      end
    end

    @event
  end

  def build_resource
    if @event.blank?
      @event = @booking_request.events.build params[:event]
      @event.event_rooms.build if @event.event_rooms.empty?
      @event.event_rooms.each do |room|
        room.available_rooms = Room.where :building_id => room.building_id if room.building_id.present?
      end
    end
    @event
  end

  def create_resource(object)
    object.save
  end

  private
  def load_available_buildings
    @buildings = Building.all #TODO: load only buildings for current org
    @rooms = Room.where :building_id => params[:building_id] if params[:building_id].present?
  end
end
