module Import
  class LoseitEntriesService
    def initialize(user)
      @user = user
    end

    def import(row)
      raw_unit = row["Units"]
      unit = case raw_unit
      when "Fluid ounces"
        "fluid_ounce"
      else
        raw_unit.downcase.singularize
      end

      if !Food.units.include?(unit)
        unit = "each"
        Rails.logger.warn "Unknown unit: #{raw_unit}"
      end

      day = @user.days.find_or_initialize_by(date: Date.strptime(row["Date"], "%m/%d/%Y"))
      meal_name = row["Type"] || row["Meal"]
      meal = day.meals.find_or_initialize_by(name: meal_name)

      quantity = row["Quantity"].to_f
      normalized_kilocalories = row["Calories"].to_f / quantity

      food = Food.find_or_initialize_by(
        name: row["Name"],
        quantity: 1,
        unit: unit,
        kilocalories: normalized_kilocalories,
      )

      debugger if food.quantity == 0

      entry = meal.food_entries.build(
        quantity: quantity,
        unit: unit,
        food: food,
      )

      ActiveRecord::Base.transaction do
        # I forgot if I actually need to save all the things, or if it would do so automatically
        day.save!
        food.save!
        meal.save!
        entry.save!
      end
    end
  end
end
