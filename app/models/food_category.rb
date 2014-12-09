class FoodCategory < ActiveRecord::Base
  has_many :foods
  after_touch :index
end
