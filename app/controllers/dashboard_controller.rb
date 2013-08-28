class DashboardController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_booking_agents, :only => :incoming

  def incoming
      @items = BookingRequest.incoming(current_user)
  end

  def sent
    @items = Event.sent(current_user)
  end

  def confirmed
    @items = Event.confirmed(current_user)
  end

  def to_invoice
    @items = Event.to_invoice(current_user)
  end

  private
  def load_booking_agents
    @booking_agents = User.joins(:roles).where('roles.name' => 'booking', :"roles.authorizable_type" => 'Organization', :"roles.authorizable_id" => current_user.organizations).reject { |user| user.id == current_user.id }
  end
end
