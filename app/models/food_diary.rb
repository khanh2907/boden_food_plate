class FoodDiary < ActiveRecord::Base
  belongs_to :participant, :foreign_key => 'participant_id'
  has_many :meals

  validates :visit, presence: true

  attr_accessor :notify_participant
end
