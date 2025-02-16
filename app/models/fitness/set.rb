module Fitness
  class Set < ApplicationRecord
    belongs_to :workout_exercise, class_name: "Fitness::WorkoutExercise"

    def completed?
      reps == planned_reps && weight == planned_weight
    end

    def failed?
      !completed?
    end
  end
end
