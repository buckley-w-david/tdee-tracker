class Meal < ApplicationRecord
  belongs_to :day

  has_many :food_entries, dependent: :destroy
  has_many :foods, through: :food_entries

  accepts_nested_attributes_for :food_entries, allow_destroy: true

  def kilocalories
    food_entries.joins(:food).pluck(:"food_entries.quantity", :"food_entries.unit", :"foods.quantity", :"foods.kilocalories", :"foods.unit").sum do |fe_quantity, fe_unit, f_quantity, f_kilocalories, f_unit|
      factor = Food::CONVERSION_FACTORS[fe_unit.to_sym][f_unit.to_sym]

      (fe_quantity * factor / f_quantity)*f_kilocalories
    end
  end
end
