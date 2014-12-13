class Meal < ActiveRecord::Base
  belongs_to :food_diary
  has_and_belongs_to_many :foods
end
