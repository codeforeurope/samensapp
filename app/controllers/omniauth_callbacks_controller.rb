class OmniauthCallbacksController < ApplicationController
  def all
    auth = request.env["omniauth.auth"]
    if signed_in?
      login = current_user.authorizations.where(auth.slice(:provider, :uid)).first_or_initialize
      login.update_attributes auth[:credentials].slice(:token, :expires_at)
      flash.notice = t(:'omniauth.facebook.success')
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


  end

  alias_method :facebook, :all
  alias_method :google_oauth2, :all

  def failure
    auth = request.env["omniauth.auth"]
    render :text => auth.to_yaml
  end
end
