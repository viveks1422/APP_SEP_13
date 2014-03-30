class UserMailer < ActionMailer::Base
  default from: "hello@bham.al"

  def welcome_email(user)
  	@user = user
  	mail to: ["hello@bham.al", "devan@bham.al"], subject: 'A new Bham Events user!'
  end
end