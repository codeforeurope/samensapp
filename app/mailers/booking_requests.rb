class BookingRequests < ActionMailer::Base
  default from: "from@example.com"

  def request_confirmation(request)
    @booking_request = request
    mail(:to => "#{request.submitter.name} <#{request.submitter.email}>", :subject => t :'.subject')

  end
end
