module Fitness
  class Set < ApplicationRecord
    belongs_to :workout_exercise, class_name: "Fitness::WorkoutExercise"

    def completed?
      !dnf? && reps >= planned_reps && weight >= planned_weight
    end

    def failed?
      !dnf? && !completed?
    end

    def dnf?
      reps.nil?
    end

    def status
      if completed?
        :completed
      elsif failed?
        :failed
      else
        :dnf
      end
    end
  end
end
