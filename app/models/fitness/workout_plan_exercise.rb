module Fitness
  class WorkoutPlanExercise < ApplicationRecord
    belongs_to :workout_plan, class_name: "Fitness::WorkoutPlan"
    belongs_to :exercise, class_name: "Fitness::Exercise"

    has_many :set_plans, dependent: :destroy, class_name: "Fitness::SetPlan"

    accepts_nested_attributes_for :set_plans, allow_destroy: true
  end
end
