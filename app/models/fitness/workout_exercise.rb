module Fitness
  class WorkoutExercise < ApplicationRecord
    belongs_to :workout, class_name: "Fitness::Workout"
    belongs_to :exercise, class_name: "Fitness::Exercise"

    has_many :sets, dependent: :destroy, class_name: "Fitness::Set"

    accepts_nested_attributes_for :sets, allow_destroy: true
  end
end
