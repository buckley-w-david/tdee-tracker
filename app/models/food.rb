class Food < ApplicationRecord
  include Units

  has_many :food_entries
end
