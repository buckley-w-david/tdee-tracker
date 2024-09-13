class Day
  class Meal < ApplicationRecord
    self.table_name = "meals"

    belongs_to :day

    has_many :foods
  end
end
