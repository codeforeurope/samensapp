

class RoomsController < InheritedResources::Base
  include ::GoogleCalendar
  load_and_authorize_resource :room
  before_filter :load_calendars, :except => [:index, :show, :destroy, :new]

  # GET /rooms
  # GET /rooms.json
  def index

    @buildings = Building.all

    if params[:building_id].present?
      @rooms = Room.where('building_id = ?', params[:building_id]).order("floor desc")
      @floors= Room.where('building_id = ?', params[:building_id]).select('distinct floor').order("floor desc").group('floor').pluck(:floor)
    else
      @rooms = Room
      @floors = Room.select('distinct floor').order('floor desc').group('floor').pluck(:floor)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rooms }
    end
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
    @room = Room.find(params[:id])
    @attachable_picture = @room
    @pictures = @attachable_picture.pictures
    @picture = Picture.new
    @room_configurations = @room.room_configurations.order("name asc")


    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @room }
    end
  end


  def in_building
    @rooms = Room.where :building_id => params[:building_id].to_i
    render layout: false
  end

  def prices
    @room = Room.find(params[:id])
    respond_to do |format|
      format.json { render json: {:gratis => 0.0, :base_price => @room.base_price, :blind_price => @room.blind_price} }
    end
  end


  protected
  def load_calendars
    if signed_in? && (can? :update, @room) && @room.building.organization.google_refresh_token.present?
      client = calendar_client(@room.building.organization)
      @calendars = client.execute(:api_method => calendar_api(@room.building.organization).calendar_list.list).data.items
    end
  end
end
