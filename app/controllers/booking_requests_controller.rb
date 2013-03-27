class BookingRequestsController < ApplicationController
  before_filter :authenticate_user!, :except => [:new, :create, :by_code]
  load_and_authorize_resource :except => [:create, :index, :by_code]

  # GET /booking_requests
  # GET /booking_requests.json
  def index

    #@unassigned_booking_requests = BookingRequest.where("assignee_id IS NULL").order("created_at desc")
    #@assigned_booking_requests = BookingRequest.where("assignee_id IS NOT NULL").order("created_at desc")
    @not_assigned_to_me_booking_requests = BookingRequest.where("assignee_id != ? OR assignee_id IS NULL", current_user.id).order("created_at desc")
    @assigned_to_me_booking_requests = BookingRequest.where("assignee_id = ? ", current_user.id).order("created_at desc")

    @booking_agents = User.joins(:roles).where('roles.name' => 'booking')

    @booking_requests = !current_user.nil? ? current_user.booking_requests : []
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @booking_requests }
    end
  end

  def assign_to_user
    logger.info(params[:assignee_id])
    @booking_request = BookingRequest.find(params[:id])
    @booking_request.assignee_id = params[:assignee_id]

    respond_to do |format|
      if @booking_request.save
        format.html { redirect_to :action => :index, notice: 'Booking request was successfully assigned.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @booking_requests, notice: 'Booking request was not assigned.' }
        format.json { render json: @booking_request.errors, status: :unprocessable_entity }
      end
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
    @booking_request.submitter = User.new()

    # we will default to current user for logged in people
    if signed_in?
      if cannot? :create_on_behalf, BookingRequest
        @booking_request.submitter = current_user
      else
        if params[:submitter_id]
          @booking_request.submitter = User.find(params[:submitter_id])
        end
      end

    end
    @booking_request.submitter.is_submitter = true

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
    #first, let's get the submitter hash out so that there can't be any overwriting
    submitter_attributes = params[:booking_request].delete :submitter_attributes

    #create a booking request with everything but the user hash
    @booking_request = BookingRequest.new(params[:booking_request])


    #lookup the submitter by email or create one with hash provided
    submitter = User.find_all_by_email(submitter_attributes[:email]).first || User.new(submitter_attributes)
    #and make the submitter the submitter
    @booking_request.submitter = submitter

    if signed_in?
      # if signed in and not able to submit request on others behalf, then we restrict to the current user
      if cannot? :create_on_behalf, BookingRequest
        # force to current user for people who can submit on behalf
        @booking_request.submitter = current_user
      end
    end


    @booking_request.submitter.submitter_hash = submitter_attributes
    #submitter.valid?

    #if submitted is persisted, we need to see if it's activated. If so they must log in first.
    if @booking_request.submitter.persisted?
      if !@booking_request.submitter.confirmed?
        #update attributes if they are missing
        @booking_request.submitter.address = submitter_attributes[:address] if @booking_request.submitter.address.blank?
        @booking_request.submitter.phone = submitter_attributes[:phone] if @booking_request.submitter.phone.blank?
        @booking_request.submitter.mobile_phone = submitter_attributes[:mobile_phone] if @booking_request.submitter.mobile_phone.blank?
      end
      if @booking_request.submitter.id == current_user.id || can?(:create_on_behalf, BookingRequest)
        @booking_request.submitter.address = submitter_attributes[:address]
        @booking_request.submitter.phone = submitter_attributes[:phone]
        @booking_request.submitter.mobile_phone = submitter_attributes[:mobile_phone]
      end

    else
      if submitter_attributes[:password].blank? && submitter_attributes[:password_confirmation].blank?
        @booking_request.submitter.make_silent
      end
    end

    #blahblah


    respond_to do |format|
      if @booking_request.save

        redirect_url = booking_request_url @booking_request
        if !signed_in?
          redirect_url = '/view_request/' + @booking_request.code
        end
        BookingRequestsMailer.request_confirmation(@booking_request, redirect_url).deliver()
        format.html { redirect_to redirect_url, notice: 'Booking request was successfully created.' }
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

  def find_user_by_email
    @users = User.where(["email LIKE ?", "%#{params[:email]}%"])
    respond_to do |format|
      format.html {
        render :partial => "user_list", :locals => {:users => @users}
      }

    end
  end


end
