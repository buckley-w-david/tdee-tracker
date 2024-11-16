class Meal < ApplicationRecord
  belongs_to :day

  has_many :food_entries, dependent: :destroy
  has_many :foods, through: :food_entries

  accepts_nested_attributes_for :food_entries, allow_destroy: true

  def kilocalories
    food_entries.includes(:food).sum(&:kilocalories)
  end
end
