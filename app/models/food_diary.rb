class FoodDiary < ActiveRecord::Base
  belongs_to :participant, :foreign_key => 'participant_id'
  has_many :meals

  validates :visit_number, presence: true
  validates :visit_number, numericality: { only_integer: true, greater_than: 0 }
end
