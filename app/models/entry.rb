class Entry < ApplicationRecord
  belongs_to :user

  validates :date, uniqueness: { scope: :user }

  after_save :update_tdee, if: :weight_previously_changed?
  after_save :refresh_invalidated_tdees

  private

  def update_tdee
    tdee = user
      .total_daily_expended_energies
      .create_with(span: 49) # TODO: Don't hardcode this
      .find_or_initialize_by(date:)

    tdee.update!(
      tdee: TdeeService.calculate(user, date, 49)
    )
  end

  def refresh_invalidated_tdees
    RefreshTdeesJob.perform_later(user.id, date)
  end
end
