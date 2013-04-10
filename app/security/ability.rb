class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      #can :discount, :offer
      can :manage, :all
    else
      if user.has_role? :booking
        can :manage, BookingRequest
        can :manage, RoomConfiguration
        can :manage, Building
        can :manage, Room
        can :create_on_behalf, BookingRequest
        cannot :assign_to_other, BookingRequest
        can :assign_to_self, BookingRequest
      else
        can [:create], BookingRequest
        can [:cancel, :read], BookingRequest do |request|
          user.id == request.submitter_id
        end
        can [:update], BookingRequest do |request|
          user.id == request.submitter_id && request.status == "submitted"
        end



      end
      #can :read, :all
      #cannot :index, BookingRequest
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
