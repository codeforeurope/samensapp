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
      if user.role? :booking, Organization
        cannot :assign_to_other, BookingRequest
        can :create_on_behalf, BookingRequest
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

      can :cancel, BookingRequest do |request, params|
        false
        #organization = request.building.organization
        #if params.present? && params.has_key?(:code) && user.new_record?
        #  result = (request.code == params[:code] && ![:canceled].include?(request.status.to_sym))
        #else
        #  result = ((user.role? :booking, organization) || user.id == request.submitter.id) && ![:canceled].include?(request.status.to_sym)
        #end
        #result
      end

      can :read, Event do |event|
        event.booking_request.submitter.id == current_user.id
      end


      can [:new, :read, :edit, :update, :destroy], Event do |event|
        request = event.booking_request
        organization = request.building.organization
        (user.role? :admin, organization) || (
        (user.role? :booking, organization) && ([:submitted, :completed].include?(request.status.to_sym) || (request.status == "assigned" && request.assignee_id == user.id))
        )

      end

      can :send_offer, Event do |event|
        request = event.booking_request
        organization = request.building.organization
        (user.role? :booking, organization) && (event.status.to_sym == :new ||event.status.to_sym == :sent)
      end


      can [:accept, :decline], Event do |event, params|
        if params.present? && params.has_key?(:code) && user.new_record?
          result = (event.code == params[:code] && event.status.to_sym == :sent)
        else
          result = (user.id == event.booking_request.submitter.id && event.status.to_sym == :sent)
        end
        result
      end

      can :cancel, Event do |event, params|
        request = event.booking_request
        organization = request.building.organization
        if params.present? && params.has_key?(:code) && user.new_record?
          result = (event.code == params[:code] && ![:canceled, :sent].include?(event.status.to_sym))
        else
          result = ((user.role? :booking, organization) || user.id == event.booking_request.submitter.id) && ![:canceled].include?(event.status.to_sym)
        end
        result
      end

      can :manage, RoomConfiguration do |configuration|
        organization = configuration.room.building.organization
        user.role? :admin, organization
      end

      can [:carousel], Picture

      ##special case for create/new

      can :manage, Room do |room|
        if room.building.present?
          organization = room.building.organization
          user.role? "admin", organization
        else
          user.role? "admin", Organization
        end

      end

      can :prices, Room do |room|
        organization = room.building.organization
        user.role? "booking", organization
      end

      can [:edit, :update, :new, :create, :destroy], Building do |building|
        if building.organization.present?
          organization = building.organization
          user.role? :admin, organization
        else
          user.role? "admin", Organization
        end

      end


      can [:update, :destroy], Organization do |organization|
        user.role? "admin", organization
      end

      if user.role? :admin, Organization || (user.role? :booking, Organization)
        can :see, Organization
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
