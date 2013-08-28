class BuildingsController < InheritedResources::Base
  before_filter :authenticate_user!

  #load_and_authorize_resource :organization, :through => :building
  load_and_authorize_resource :building

  #defaults :singleton => true
  optional_belongs_to :organization


  before_filter :load_markers, :only => :index

  def openingtimes
    @building = Building.find(params[:id])
    respond_to do |format|
      format.html { render layout: "ajax" }
      format.json { render json: @room_configuration }
    end
  end


  def load_markers
    @json = @buildings.to_gmaps4rails do |building, marker|
      marker.json({:id => building.id, :foo => building.name})
    end
  end
end
