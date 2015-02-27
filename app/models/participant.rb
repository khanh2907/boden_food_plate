class Participant < ActiveRecord::Base
  enum gender: [:male, :female, :other]
  has_many :food_diaries

  validates :pid, presence: true
  validates :pid, length: { is: 5 }
  validates :pid, format: {with: /\d{2}\/[a-zA-Z]{2}/}

  validates :date_of_birth, presence: true
  validates :gender, presence: true

  def date_of_birth_formatted
    date_of_birth.strftime('%d/%m/%Y')
  end
end
