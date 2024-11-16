module Units
  extend ActiveSupport::Concern

  MASS_UNITS = { milligram: "mg", gram: "g", kilogram: "kg", pound: "lb" }
  VOLUME_UNITS = { teaspoon: "tsp", tablespoon: "tbsp", milliliter: "ml", liter: "l", cup: "cup", fluid_ounce: "fl oz" }
  OTHER_UNITS = { item: "each" }

  COMPATIBLE_UNITS, COMPATIBLE_UNIT_NAMES = [ MASS_UNITS, VOLUME_UNITS, OTHER_UNITS ].each_with_object([ {}, {} ]) do |unit_group, (units, names)|
    unit_group.each do |unit_name, unit_unit|
      names[unit_name] = unit_group.keys
      units[unit_unit] = unit_group.values
    end
  end

  CONVERSION_FACTORS = {
    milligram: {
      milligram: 1,
      gram: 1.0 / 1000,
      kilogram: 1.0 / (1000*1000),
      pound: 1.0 / 453592
    },
    gram: {
      milligram: 1000,
      gram: 1,
      kilogram: 1.0 / 1000,
      pound: 1.0 / 453.592
    },
    kilogram: {
      milligram: 1000*1000,
      gram: 1000,
      kilogram: 1,
      pound: 1.0 / 0.453592
    },
    pound: {
      milligram: 453592,
      gram: 453.592,
      kilogram: 0.453592,
      pound: 1
    },
    teaspoon: {
      teaspoon: 1,
      tablespoon: 1.0 / 3,
      cup: 1.0 / 48,
      milliliter: 4.92,
      liter: 4.92 * 1000,
      fluid_ounce: 1.0 / 6
    },
    tablespoon: {
      teaspoon: 3,
      tablespoon: 1,
      cup: 1.0 / 16,
      milliliter: 14.79,
      liter: 14.79 * 1000,
      fluid_ounce: 1.0 / 2
    },
    cup: {
      teaspoon: 48,
      tablespoon: 16,
      cup: 1,
      milliliter: 236.588,
      liter: 236.588 * 1000,
      fluid_ounce: 8
    },
    milliliter: {
      teaspoon: 1.0 / 4.92,
      tablespoon: 1.0 / 14.79,
      cup: 1.0 / 236.588,
      milliliter: 1,
      liter: 1.0 / 1000,
      fluid_ounce: 1.0 / 29.5735
    },
    liter: {
      teaspoon: 1.0 / (4.92 * 1000),
      tablespoon: 1.0 / (14.79 * 1000),
      cup: 1.0 / (236.588 * 1000),
      milliliter: 1000,
      liter: 1,
      fluid_ounce: 1.0 / 29.573
    },
    fluid_ounce: {
      teaspoon: 1.0 / 6,
      tablespoon: 1.0 / 2,
      cup: 1.0 / 8,
      milliliter: 29.5735,
      liter: 29.5735 * 1000,
      fluid_ounce: 1
    },
    item: {
      item: 1
    }
  }

  included do
    enum :unit, {
      **MASS_UNITS,
      **VOLUME_UNITS,
      **OTHER_UNITS
    }

    def compatible_units
      COMPATIBLE_UNIT_NAMES[unit.to_sym]
    end
  end
end
