class Day < ApplicationRecord
  belongs_to :user

  validates :date, uniqueness: { scope: :user }

  before_validation :update_tdee, if: :weight_changed?
  after_save :refresh_invalidated_tdees, if: -> { weight_previously_changed? || kilocalories_previously_changed? }

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

  private

  def update_tdee
    self.total_daily_expended_energy = TdeeService.calculate(self)
  end

  def refresh_invalidated_tdees
    RefreshTdeesJob.perform_later(id)
  end
end
