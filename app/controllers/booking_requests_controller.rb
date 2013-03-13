class BookingRequestsController < ApplicationController
  before_filter :authenticate_user!, :except => [:new, :create, :by_code]
  load_and_authorize_resource :except => [:create, :index, :by_code]

  # GET /booking_requests
  # GET /booking_requests.json
  def index
    @booking_requests = !current_user.nil? ? current_user.booking_requests : []
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

  def by_code
    @booking_request = BookingRequest.find_all_by_code(params[:code]).first
    respond_to do |format|
      format.html # by_code.html.erb
      format.json { render json: @booking_request }
    end
  end

  # GET /booking_requests/new
  # GET /booking_requests/new.json
  def new

    # we will default to current user for logged in people
    if !current_user.nil?
      @booking_request.submitter = current_user
    else
      @booking_request.submitter = User.new()
    end


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
    submitter_attributes = params[:booking_request].delete :submitter_attributes

    # if user can create requests on behalf of others
    # then there are 2 cases - existing user, new user

    submitter = User.find_all_by_email(submitter_attributes[:email]).first

    if !current_user.nil?
      if cannot? :create_on_behalf, BookingRequest
        # force to current user for people who can submit on behalf
        submitter = current_user
      end
    else
      if submitter.nil?
        submitter = User.new(submitter_attributes)
        submitter.make_silent

      end
    end

    @booking_request = BookingRequest.new(params[:booking_request])
    @booking_request.submitter = submitter

    respond_to do |format|
      if @booking_request.save
        format.html {
          if !current_user.nil?
            redirect_url = booking_request_url @booking_request
          else
            redirect_url = '/view_request/' + @booking_request.code
          end
          redirect_to redirect_url, notice: 'Booking request was successfully created.'
        }
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
