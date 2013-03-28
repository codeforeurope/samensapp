class BookingRequestsMailer < ActionMailer::Base
  default from: "De Meevaart <demeevaart@gmail.com>"

  def request_confirmation(request, target_url)
    @booking_request = request
    @target_url = target_url
    mail(:to => "#{request.submitter.name} <#{request.submitter.email}>",
         :subject => t(:'mailer.request_confirmation.subject', :id => request.id.to_s),
         :content_type => "text/html"
    )

  end
end
