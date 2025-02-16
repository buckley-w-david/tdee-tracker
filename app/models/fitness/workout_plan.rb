module Fitness
  class WorkoutPlan < ApplicationRecord
    belongs_to :routine, class_name: "Fitness::Routine"

    has_many :workout_plan_exercises, dependent: :destroy, class_name: "Fitness::WorkoutPlanExercise"
    has_many :exercises, through: :workout_exercises, class_name: "Fitness::Exercise"

    has_many :workouts, class_name: "Fitness::Workout"

    accepts_nested_attributes_for :workout_plan_exercises, allow_destroy: true
  end
end
