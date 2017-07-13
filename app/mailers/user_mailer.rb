class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "the nutrition algorithm account activation"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "the nutrition algorithm password reset"
  end
  
end