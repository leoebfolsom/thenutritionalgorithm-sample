class SpoonMailer < ApplicationMailer

  def spoon_mailer(list_id, user_id, spooning_user_id)
    @list = List.find(list_id)
    @user = User.find(user_id)
    @spooning_user = User.find(spooning_user_id)
    mail to: @user.email, subject: "Your list, #{@list.name}, has been spooned.", from: "admin@thenutritionalgorithm.com"
  end

end