require 'google/api_client'
module GoogleCalendar

  protected
  def calendar_client(organization)
    if @calendar_clients.blank?
      @calendar_clients = {}
    end
    if @calendar_clients[organization.id].blank?
      @calendar_clients[organization.id] = Google::APIClient.new
      @calendar_clients[organization.id].authorization.client_id=ENV["GOOGLE_CLIENT_ID"]
      @calendar_clients[organization.id].authorization.client_secret=ENV["GOOGLE_CLIENT_SECRET"]
      @calendar_clients[organization.id].authorization.update_token!({
                                                                         :access_token => organization.google_token,
                                                                         :refresh_token => organization.google_refresh_token,
                                                                         :expires_in => organization.google_token_expires_at - Time.now.to_i
                                                                     })
      if @calendar_clients[organization.id].authorization.expired?
        result = @calendar_clients[organization.id].authorization.fetch_access_token!
        organization.update_attributes :google_token => result["access_token"], :google_token_expires_at => Time.now.to_i + result["expires_in"]
      end
    end
    @calendar_clients[organization.id]
  end

  def calendar_api(organization)
    if @calendar_api.blank?
      @calendar_api = {}
    end
    if @calendar_api[organization.id].blank?
      @calendar_api[organization.id] = calendar_client(organization).discovered_api('calendar', 'v3')
    end
    @calendar_api[organization.id]
  end
end