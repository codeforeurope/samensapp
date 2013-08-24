class OrganizationsController < InheritedResources::Base
  before_filter :authenticate_user!, :except => [:index, :show]
  load_and_authorize_resource :organization
  def index
    if can? :new, Organization
      @verified = @organizations.where("status = 'verified'")
      @not_verified = @organizations.where("status != 'verified'")
    end
    @my_organizations = current_user.organizations

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @organizations }
    end
  end

# GET /organizations/1
# GET /organizations/1.json
  def show
    @buildings = @organization.buildings
    super
  end


# POST /organizations
# POST /organizations.json
  def create
    create! do |success, failure|
      success.html {
        redirect_to params[:organization][:image].present? ? crop_organization_url(@organization) : organization_url(@organization)
      }
    end
  end

# PUT /organizations/1
# PUT /organizations/1.json
  def update
    update! do |success, failure|
      success.html {
        redirect_to params[:organization][:image].present? ? crop_organization_url(@organization) : organization_url(@organization)
      }
    end
  end

  def crop
  end

end
