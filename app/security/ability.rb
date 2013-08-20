class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)

    if user.role? :global_admin.to_s
      can :manage, :all
    else
      #cannot :make_offer, BookingRequest
      if user.role? :booking
        cannot :assign_to_other, BookingRequest
      end


      can :create_on_behalf, BookingRequest do |request|
        if request.building.nil?
          return true
        else
          organization = request.building.organization
          return user.role? :booking, organization
        end
      end
      can :assign_to_self, BookingRequest do |request|
        # if the request is for one of the buildings I have booking privs to
        organization = request.building.organization
        (user.role? :booking, organization)
      end
      can :assign_to_other, BookingRequest do |request|
        # if the request is for one of the buildings I have booking privs to
        organization = request.building.organization
        user.role? :admin, organization
      end
      can :make_offer, BookingRequest do |request|
        organization = request.building.organization
        (user.role? :booking, organization) && (request.status == "submitted" || (request.status == "assigned" && request.assignee_id == user.id))
      end

      can :read, Event do |event|
        event.booking_request.submitter.id == current_user.id
      end

      can [:new, :read, :edit, :update, :cancel, :send_offer, :destroy, :index], Event do |event|
        request = event.booking_request
        organization = request.building.organization
        (user.role? :booking, organization) && (request.status == "submitted" || (request.status == "assigned" && request.assignee_id == user.id))
      end

      can [:accept, :decline] , Event do |event|
        user.id == event.booking_request.submitter.id
      end
      can :manage, RoomConfiguration do |configuration|
        organization = configuration.room.building.organization
        user.role? "admin", organization
      end
      can :manage, Room do |room|
        organization = room.building.organization
        user.role? "admin", organization
      end
      can :manage, Building do |building|
        organization = building.organization
        user.role? "admin", organization
      end
      can [:update, :destroy], Organization do |organization|
        user.role? "admin", organization
      end


      can [:create, :find_user_by_email], BookingRequest
      can [:cancel, :read], BookingRequest do |request|
        user.id == request.submitter_id
      end
      can [:update], BookingRequest do |request|
        user.id == request.submitter_id && request.status == "submitted"
      end


      can :read, :all
    end


    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
