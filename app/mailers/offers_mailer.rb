class OffersMailer < ActionMailer::Base
  default from: "De Meevaart <demeevaart@gmail.com>"

  def offer_notification(event)
    @event = event
    @booking_request = event.booking_request
    @link_to_offer = @booking_request.submitter.confirmed? ? booking_request_offer_url(@booking_request) : view_offer_url(event.code)
    mail(:from => "#{@booking_request.building.organization.name} <#{@booking_request.building.organization.email}>",
         :to => "#{@booking_request.submitter.name} <#{@booking_request.submitter.email}>",
         :subject => t(:'offers_mailer.offer_notification.subject', :id => event.id.to_s),
         :content_type => "text/html"
    )
  end
end
