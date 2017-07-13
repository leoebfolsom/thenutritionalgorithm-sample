# Preview all emails at http://localhost:3000/rails/mailers/example_mailer
class ChecklistMailerPreview < ActionMailer::Preview
  def checklist_mailer_preview
    ChecklistMailer.checklist_mailer(List.all.sample.id, User.all.sample.id)
  end
end