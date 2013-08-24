class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    auth = request.env["omniauth.auth"]
    if session['omniauth.organization_id'].blank?
      if signed_in?
        login = current_user.authorizations.where(auth.slice(:provider, :uid)).first_or_initialize
        login.update_attributes auth[:credentials].slice(:token, :expires_at)
        flash.notice = t(:'omniauth.login.success')
        redirect_to home_path
      else
        user = User.from_omniauth(auth)
        if user.persisted?
          flash.notice = t(:signed_in)
          user.confirm! unless user.confirmed?
          sign_in_and_redirect user
        else
          session["devise.login_attributes"] = auth.slice(:provider, :uid).merge(auth[:credentials].slice(:token, :expires_at))
          session["devise.user_attributes"] = user.attributes
          redirect_to new_user_registration_url
        end
      end
    else
      @organization = Organization.find(session['omniauth.organization_id'])
      if auth[:info][:email] == @organization.email
        @organization.update_attributes :google_token => auth[:credentials][:token], :google_token_expires_at => auth[:credentials][:expires_at], :google_refresh_token => auth[:credentials][:refresh_token]
        flash.notice = t(:"organizations.calendar.success", :email => auth[:info][:email])
      else
        set_flash_message :alert, :failure, :kind => OmniAuth::Utils.camelize(:google_oauth2), :reason => t(:"organizations.calendar.failure.email_mismatch", :email_oauth => auth[:info][:email], :email_organization => @organization.email)
      end
      redirect_to organization_path(@organization)
    end


  end

  alias_method :facebook, :all
  alias_method :google_oauth2, :all

  def setup

    if params[:organization_id].present?
      request.env['omniauth.strategy'].options[:scope] = "userinfo.email, userinfo.profile, https://www.googleapis.com/auth/calendar"
      session['omniauth.organization_id'] = params[:organization_id]
    else
      if params[:state].present? && params[:code].present?
        # do something special with
        session['omniauth.organization_id']
      end
      request.env['omniauth.strategy'].options[:scope] = "userinfo.email, userinfo.profile"

    end
    render :text => "Setup complete.", :status => 404
  end

  #def passthru
  #  super
  #end
end

