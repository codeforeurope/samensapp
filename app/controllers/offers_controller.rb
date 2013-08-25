class OffersController < InheritedResources::Base
  before_filter :authenticate_user!, :except => [:by_code, :accept, :decline]
  before_filter :load_available_buildings
  load_and_authorize_resource :booking_request, :through => :event
  load_and_authorize_resource :event
  defaults :resource_class => 'Event', :singleton => true, :instance_name => :event
  optional_belongs_to :booking_request

  layout Proc.new { |controller| (controller.request.xhr?) ? 'ajax' : 'application' }
  before_filter :resource, :only => [:accept, :decline, :cancel, :send_offer]


  def by_code

    @event = Event.find_all_by_code(params[:code]).first
    @booking_request = @event.booking_request

    render :action => :show

  end

  def create
    create! {
      booking_request_offer_url(@booking_request)
    }
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
    authorize! :send_offer, @event, params
    if add_events_to_google_calendars
      OffersMailer.offer_notification(@event).deliver
      @event.status = :sent
      update! do |format|
        format.html {
          redirect_to booking_request_offer_url(@booking_request)
        }
      end
    else
      redirect_to booking_request_offer_url(@booking_request)
    end
  end


  def rooms_for_event
    render layout: false
  end

  protected

  def add_events_to_google_calendars
    @event.event_rooms.each do |event_room|
      if event_room.calendar_event_id.blank?
        client = calendar_client(event_room.room.building.organization)
        calendar_event = event_room.to_google_calendar_json
        result = client.execute(:api_method => calendar_api(event_room.room.building.organization).events.insert,
                                :parameters => {:calendarId => event_room.room.google_calendar},
                                :body => calendar_event,
                                :headers => {'Content-Type' => 'application/json'})
        if result.status >= 200 && result.status < 300
          event_room.update_attribute :calendar_event_id, result.data.id
        else
          flash.error = t(:unable_to_save_event_in_calendar)
        end
      end
    end
  end

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
