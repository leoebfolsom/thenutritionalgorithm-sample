# Preview all emails at http://localhost:3000/rails/mailers/example_mailer
class StripeMailerPreview < ActionMailer::Preview
  def stripe_mailer_preview
    StripeMailer.stripe_mailer(User.all.sample.id, "subscribe")
  end
end