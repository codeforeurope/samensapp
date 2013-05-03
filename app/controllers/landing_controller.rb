class LandingController < ApplicationController
  def index
    @events = Event.where(status: :confirmed).order("start_at ASC")
  end
end
