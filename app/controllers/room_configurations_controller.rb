class RoomConfigurationsController < ApplicationController
  # GET /room_configurations
  # GET /room_configurations.json
  def index
    @room_configurations = RoomConfiguration.all

    respond_to do |format|
      format.html # index.html.erb
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
    @room_configuration = RoomConfiguration.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @room_configuration }
    end
  end

  # GET /room_configurations/1/edit
  def edit
    @room_configuration = RoomConfiguration.find(params[:id])
  end

  # POST /room_configurations
  # POST /room_configurations.json
  def create
    @room_configuration = RoomConfiguration.new(params[:room_configuration])

    respond_to do |format|
      if @room_configuration.save
        format.html { redirect_to @room_configuration, notice: 'Room configuration was successfully created.' }
        format.json { render json: @room_configuration, status: :created, location: @room_configuration }
      else
        format.html { render action: "new" }
        format.json { render json: @room_configuration.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /room_configurations/1
  # PUT /room_configurations/1.json
  def update
    @room_configuration = RoomConfiguration.find(params[:id])

    respond_to do |format|
      if @room_configuration.update_attributes(params[:room_configuration])
        format.html { redirect_to @room_configuration, notice: 'Room configuration was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @room_configuration.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /room_configurations/1
  # DELETE /room_configurations/1.json
  def destroy
    @room_configuration = RoomConfiguration.find(params[:id])
    @room_configuration.destroy

    respond_to do |format|
      format.html { redirect_to room_configurations_url }
      format.json { head :no_content }
    end
  end
end
