class Notifier < ActionMailer::Base
  default from: Rails.application.secrets.admin_email

  def new_food_diary(participant, food_diary)
    @participant = participant
    @food_diary = food_diary
    mail(to: participant.email, subject: 'Boden Food Plate: New Food Diary')
  end
end
