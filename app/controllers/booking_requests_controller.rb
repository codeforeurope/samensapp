class BookingRequestsController < ApplicationController

  load_and_authorize_resource :except => [:create]

  # GET /booking_requests
  # GET /booking_requests.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @booking_requests }
    end
  end

  # GET /booking_requests/1
  # GET /booking_requests/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @booking_request }
    end
  end

  # GET /booking_requests/new
  # GET /booking_requests/new.json
  def new
    @booking_request.submitter = User.new()
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @booking_request }
    end
  end

  # GET /booking_requests/1/edit
  def edit
  end

  # POST /booking_requests
  # POST /booking_requests.json
  def create
    submitter_hash =params[:booking_request].delete :submitter
    submitter = User.find_all_by_email(submitter_hash[:email]).first || User.new(submitter_hash)

    @booking_request = BookingRequest.new(params[:booking_request])
    @booking_request.submitter = submitter

    respond_to do |format|
      if @booking_request.save
        format.html { redirect_to @booking_request, notice: 'Booking request was successfully created.' }
        format.json { render json: @booking_request, status: :created, location: @booking_request }
      else
        format.html { render action: "new" }
        format.json { render json: @booking_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /booking_requests/1
  # PUT /booking_requests/1.json
  def update

    respond_to do |format|
      if @booking_request.update_attributes(params[:booking_request])
        format.html { redirect_to @booking_request, notice: 'Booking request was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @booking_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /booking_requests/1
  # DELETE /booking_requests/1.json
  def destroy
    @booking_request.destroy

    respond_to do |format|
      format.html { redirect_to booking_requests_url }
      format.json { head :no_content }
    end
  end

end
