class Day < ApplicationRecord
  belongs_to :user

  validates :date, uniqueness: { scope: :user }

  # I have screwed _something_ up to require specifying class_name here
  # I am just not sure what
  has_many :meals, class_name: "::Meal", dependent: :destroy
  has_many :food_entries, through: :meals

  def meal_kilocalories
    food_entries.includes(:food).sum(&:kilocalories)
  end

  class << self
    def today
      Day.find_by(date: Time.current.to_date)
    end
  end
end
