class StripeMailer < ApplicationMailer

  def stripe_mailer(user_id,event)
    @user = User.find(user_id)
    @event = event
    mail to: "leo.e.brown@gmail.com", subject: "SOMETHING HAPPENED", from: "admin@thenutritionalgorithm.com"
  end

end