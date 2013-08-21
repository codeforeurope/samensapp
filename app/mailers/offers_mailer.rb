class OffersMailer < ActionMailer::Base
  default from: "De Meevaart <demeevaart@gmail.com>"

  def offer_notification(event, target_url)
    @event = event
    @target_url = target_url
    mail(:from => "#{request.building.organization.name} <#{request.building.organization.email}>",
         :to => "#{request.submitter.name} <#{request.submitter.email}>",
         :subject => t(:'mailer.request_confirmation.subject', :id => request.id.to_s),
         :content_type => "text/html"
    )
  end
end
