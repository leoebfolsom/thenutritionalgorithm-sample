class ListbuyMailer < ApplicationMailer

  def listbuy_mailer(list_id, user_id, listbuying_user_id)
    @list = List.find(list_id)
    @user = User.find(user_id)
    @listbuying_user = User.find(listbuying_user_id)
    if @user == @listbuying_user
      subject = "Congratulations! A summary of your groceries."
    else
      subject = "Congratulations! #{@listbuying_user.name} bought food from your list."
    end
    mail to: @user.email, subject: subject, from: "admin@thenutritionalgorithm.com"
  end

end