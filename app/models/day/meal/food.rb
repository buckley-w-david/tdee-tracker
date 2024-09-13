class Day
  class Meal
    class Food < ApplicationRecord
      self.table_name = "foods"

      belongs_to :meal
    end
  end
end
