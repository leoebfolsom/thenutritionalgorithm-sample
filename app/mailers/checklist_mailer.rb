class ChecklistMailer < ApplicationMailer

  def checklist_mailer(list_id, user_id)
    @list = List.find(list_id)
    @user = User.find(user_id)
    mail to: @user.email, subject: @list.name, from: "admin@thenutritionalgorithm.com"
  end

end