class OffersController < InheritedResources::Base
  before_filter :authenticate_user!, :except => [:new, :create, :by_code]
  before_filter :load_available_buildings
  load_and_authorize_resource :booking_request, :through => :event
  load_and_authorize_resource :event
  defaults :resource_class => 'Event', :singleton => true, :instance_name => :event
  belongs_to :booking_request

  layout Proc.new { |controller| (controller.request.xhr?) ? 'ajax' : 'application' }

  def create
    super
  end

  def accept
  end

  def decline
  end

  def invalidate
  end

  def rooms_for_event
    render layout: false
  end

  protected
  def resource
    if @event.blank?
      @event = @booking_request.events.first
      @event.event_rooms.each do |event_room|
        event_room.building_id = event_room.room.building.id
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
