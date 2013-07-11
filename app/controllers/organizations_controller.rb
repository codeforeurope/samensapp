class OrganizationsController < ApplicationController
  before_filter :authenticate_user!, :except=>[:index,:show]
  load_and_authorize_resource
  #TODO: use load_and_authorize_resource  + before_filter for applying authorizations
  #load_resource

  # GET /organizations
  # GET /organizations.json
  def index
    @organizations = Organization.all

    @verified = Organization.where("status = 'verified'")
    @not_verified = Organization.where("status != 'verified'")



    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @organizations }
    end
  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
    @organization = Organization.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @organization }
    end
  end

  # GET /organizations/new
  # GET /organizations/new.json
  def new
    @organization = Organization.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @organization }
    end
  end

  # GET /organizations/1/edit
  def edit
    @organization = Organization.find(params[:id])
  end

  # POST /organizations
  # POST /organizations.json
  def create
    respond_to do |format|
      if @organization.save
        format.html {
          if params[:organization][:image].present?
            redirect_to crop_organization_url(@organization), notice: 'Organization was successfully created.'
          else
            redirect_to organization_url(@organization), notice: 'Organization was successfully created.'
          end
        }
        format.json { render json: @organization, status: :created, location: @organization }
      else
        format.html { render action: "new" }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /organizations/1
  # PUT /organizations/1.json
  def update
    @organization = Organization.find(params[:id])

    respond_to do |format|
      if @organization.update_attributes(params[:organization])
        format.html {
          if params[:organization][:image].present?
            redirect_to crop_organization_url(@organization), notice: 'Organization was successfully updated.'
          else
            redirect_to organization_url(@organization), notice: 'Organization was successfully updated.'
          end
        }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
    @organization = Organization.find(params[:id])
    @organization.destroy

    respond_to do |format|
      format.html { redirect_to organizations_url }
      format.json { head :no_content }
    end
  end

  def crop
  end

end
