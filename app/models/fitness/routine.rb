module Fitness
  class Routine < ApplicationRecord
    belongs_to :user

    has_many :workout_plans, dependent: :destroy, class_name: "Fitness::WorkoutPlan"
    # has_many :workouts, dependent: :destroy, class_name: "Fitness::Workout"

    accepts_nested_attributes_for :workout_plans, allow_destroy: true

    after_create :schedule_workouts

    # TODO: more flexible scheduling
    #       For now just hardcoding Monday, Wednesday, Friday cycle
    def schedule!(workout_plan)
      workout_plans.max_by(&:planned_date).tap do |last_workout|
        last_workout_date = last_workout.planned_date || Date.current
        candidates = [ :monday, :wednesday, :friday ].map { |day| last_workout_date.next_occurring(day) }
        workout_plan.planned_date = candidates.min_by { |date| (date - Date.current).abs }
      end

      recent_workouts = workout_plan.workouts.order(date: :desc, created_at: :desc).first(3)

      # NOTE: ASSUMPTION A workout will only have one instance of a given exercise
      # We cannot blindly link workout exercises to exercise plans for differentiation, because the plans change out from under us
      # We can scan the workout exercises for this scenario and handle it explicitly if it becomes a problem
      recent_performance = {}
      recent_workouts.each do |workout|
        workout.workout_exercises.each do |workout_exercise|
          recent_performance[workout_exercise.exercise_id] ||= []
          recent_performance[workout_exercise.exercise_id] << workout_exercise.status
        end
      end

      workout_plan.workout_plan_exercises.each do |workout_plan_exercise|
        next if recent_performance[workout_plan_exercise.exercise_id].nil?

        if recent_performance[workout_plan_exercise.exercise_id].first == :completed
          workout_plan_exercise.set_plans.each do |set_plan|
            if workout_plan_exercise.reps_progression?
              new_reps = set_plan.reps + workout_plan_exercise.reps_progression
              if workout_plan_exercise.weight_progression? && new_reps > workout_plan_exercise.auto_reps_max
                set_plan.reps = workout_plan_exercise.auto_reps_min
                set_plan.weight += workout_plan_exercise.weight_progression
              else
                set_plan.reps = [ new_reps, workout_plan_exercise.auto_reps_max ].min
              end
            elsif workout_plan_exercise.weight_progression?
              set_plan.weight += workout_plan_exercise.weight_progression
            end
          end
        # FIXME: We should probably only check for failures _at the same weight and reps_
        elsif recent_performance[workout_plan_exercise.exercise_id] == [ :failed, :failed, :failed ]
          workout_plan_exercise.set_plans.each do |set_plan|
            if workout_plan_exercise.reps_progression?
              new_reps = set_plan.reps - workout_plan_exercise.reps_progression
              if workout_plan_exercise.weight_progression? && new_reps < workout_plan_exercise.auto_reps_min
                set_plan.reps = workout_plan_exercise.auto_reps_max
                set_plan.weight -= workout_plan_exercise.weight_progression
              else
                set_plan.reps = [ 1, new_reps ].max
              end
            elsif workout_plan_exercise.weight_progression?
              set_plan.weight -= workout_plan_exercise.weight_progression
            end
          end
        end
      end

      workout_plan.save!
    end

    private

    def schedule_workouts
      workout_plans.each do |plan|
        schedule!(plan)
      end
    end
  end
end
