class Fitness::SetPlan < ApplicationRecord
  belongs_to :workout_plan_exercise, class_name: "Fitness::WorkoutPlanExercise"
end
