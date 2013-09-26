class RoomConfigurationsController < ApplicationController
  load_and_authorize_resource :load_room
  before_filter :load_room

  # GET /room_configurations
  # GET /room_configurations.json
  def index
    @room_configurations = @room.room_configurations.order("name asc")

    respond_to do |format|
		  format.html { render layout: "ajax" }
      format.json { render json: @room_configurations }
    end
  end

  # GET /room_configurations/1
  # GET /room_configurations/1.json
  def show
    @room_configuration = RoomConfiguration.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @room_configuration }
    end
  end

  # GET /room_configurations/new
  # GET /room_configurations/new.json
  def new
    @room_configuration = @room.room_configurations.new

    respond_to do |format|
      format.html { render layout: "ajax" }
      format.json { render json: @room_configuration }
    end
  end

  # GET /room_configurations/1/edit
  def edit
    @room_configuration = @room.room_configurations.find(params[:id])
	  respond_to do |format|
      format.html { render layout: "ajax" }
      format.json { render json: @room_configuration }
    end
  end

  # POST /room_configurations
  # POST /room_configurations.json
  def create
    @room_configuration = @room.room_configurations.new(params[:room_configuration])

    respond_to do |format|
      if @room_configuration.save
	      format.html { head :created}
        format.json { render json: @room_configuration, status: :created, location: @room_configuration }
      else
        format.html { render action: "new" , layout: "ajax", status: 400 }
        format.json { render json: @room_configuration.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /room_configurations/1
  # PUT /room_configurations/1.json
  def update
	  @room_configuration = @room.room_configurations.find(params[:id])
	  respond_to do |format|
      if @room_configuration.update_attributes(params[:room_configuration])
	      format.html { head :ok}
        format.json { render json: @room_configuration, status: :created, location: @room_configuration }
      else
        format.html { render action: "edit" , layout: "ajax", status: 400 }
        format.json { render json: @room_configuration.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /room_configurations/1
  # DELETE /room_configurations/1.json
  def destroy
    @room_configuration = @room.room_configurations.find(params[:id])
    @room_configuration.destroy

    respond_to do |format|
      format.html { head :no_content }
      format.json { head :no_content }
    end
  end

  protected
  def load_room
	  @room = Room.find(params[:room_id])
  end
end
