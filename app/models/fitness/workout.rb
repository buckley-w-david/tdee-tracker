module Fitness
  class Workout < ApplicationRecord
    belongs_to :user
    belongs_to :workout_plan, class_name: "Fitness::WorkoutPlan"

    has_many :workout_exercises, class_name: "Fitness::WorkoutExercise", dependent: :destroy

    accepts_nested_attributes_for :workout_exercises, allow_destroy: true

    after_create :schedule_next_workout
    after_update :reasses_workout

    def routine
      workout_plan.routine
    end

    class << self
      def from_plan(workout_plan, date: Date.current)
        Fitness::Workout.new(workout_plan:, date:).tap do |workout|
          workout_plan.workout_plan_exercises.each do |workout_plan_exercise|
            workout.workout_exercises.build(exercise: workout_plan_exercise.exercise).tap do |workout_exercise|
              workout_plan_exercise.set_plans.each do |set|
                workout_exercise.sets.build(weight: set.weight, planned_reps: set.reps, planned_weight: set.weight)
              end
            end
          end
        end
      end
    end

    private

    def schedule_next_workout
      routine.schedule!(workout_plan)
      workout_plan.progress!
    end

    def reasses_workout
      # TODO: Implement
    end
  end
end
