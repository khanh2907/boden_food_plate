class DiaryDay < ActiveRecord::Base
  belongs_to :food_diary
  has_many :meals
end
