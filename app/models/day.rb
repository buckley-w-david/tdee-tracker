class Day < ApplicationRecord
  belongs_to :user

  validates :date, uniqueness: { scope: :user }

  before_validation :update_tdee, if: :weight_changed?
  after_save :refresh_invalidated_tdees, if: -> { weight_previously_changed? || kilocalories_previously_changed? }

  has_many :meals

  private

  def update_tdee
    self.total_daily_expended_energy = TdeeService.calculate(self)
  end

  def refresh_invalidated_tdees
    RefreshTdeesJob.perform_later(id)
  end
end
