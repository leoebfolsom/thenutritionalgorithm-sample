class ForkMailer < ApplicationMailer

  def fork_mailer(list_id, user_id, forking_user_id, new_list_id)
    @list = List.find(list_id)
    @user = User.find(user_id)
    @forking_user = User.find(forking_user_id)
    @new_list = List.find(new_list_id)
    mail to: @user.email, subject: "Your list, #{@list.name}, has been forked.", from: "admin@thenutritionalgorithm.com"
  end

end