
class OrganizationsController < InheritedResources::Base
  before_filter :authenticate_user!, :except => [:index, :show]
  load_and_authorize_resource :organization

  def index
    if can? :new, Organization
      @verified = @organizations.where("status = 'verified'")
      @not_verified = @organizations.where("status != 'verified'")
    end
    @my_organizations = current_user.organizations

    super
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

  def calendars
    client = Google::APIClient.new
    client.authorization.client_id=ENV["GOOGLE_CLIENT_ID"]
    client.authorization.client_secret=ENV["GOOGLE_CLIENT_SECRET"]
    client.authorization.access_token= @organization.google_token
    client.authorization.refresh_token= @organization.google_refresh_token
    calendar= client.discovered_api('calendar', 'v3')

    @calendars = client.execute(:api_method => calendar.calendar_list.list)

  end

end
