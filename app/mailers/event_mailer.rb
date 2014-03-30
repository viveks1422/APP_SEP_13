class EventMailer < ActionMailer::Base
  default from: "hello@bham.al"

  def event_creation(event)
    @event = event

    mail to: event.user.email, subject: "Event Creation Confirmation",
    	bcc: ["hello@bham.al", "devan@bham.al"]
  end
end
