class FoodEntry < ApplicationRecord
  include Units

  belongs_to :food
  belongs_to :meal

  # Units are present on both foods and entries to faciliate a (as yet unimplemented) feature where we accept sets of "compatible" units (g and kg, or even g and lbs)
  # Currently only the same unit is allowed
  validate :unit_matches_food

  private

  def unit_matches_food
    return if food.compatible_units.include?(unit.to_sym)
    errors.add(:unit, "must match the unit of the food")
  end
end
