module Units
  extend ActiveSupport::Concern

  MASS_UNITS = { milligram: "mg", gram: "g", kilogram: "kg" }
  VOLUME_UNITS = { teaspoon: "tsp", tablespoon: "tbsp", milliliter: "ml", liter: "l" }
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
      kilogram: 1.0 / (1000*1000)
    },
    gram: {
      milligram: 1000,
      gram: 1,
      kilogram: 1.0 / 1000
    },
    kilogram: {
      milligram: 1000*1000,
      gram: 1000,
      kilogram: 1
    },
    teaspoon: {
      teaspoon: 1,
      tablespoon: 1.0 / 3,
      milliliter: 4.92,
      liter: 4.92 * 1000
    },
    tablespoon: {
      teaspoon: 3,
      tablespoon: 1,
      milliliter: 14.79,
      liter: 14.79 * 1000
    },
    milliliter: {
      teaspoon: 1.0 / 4.92,
      tablespoon: 1.0 / 14.79,
      milliliter: 1,
      liter: 1.0 / 1000
    },
    liter: {
      teaspoon: 1.0 / (4.92 * 1000),
      tablespoon: 1.0 / (14.79 * 1000),
      milliliter: 1000,
      liter: 1
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
