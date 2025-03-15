module Fitness
  class Routine < ApplicationRecord
    belongs_to :user

    serialize :schedule, coder: JSON

    has_many :workout_plans, dependent: :destroy, class_name: "Fitness::WorkoutPlan"
    # has_many :workouts, dependent: :destroy, class_name: "Fitness::Workout"

    accepts_nested_attributes_for :workout_plans, allow_destroy: true

    after_create :schedule_workouts
    after_update :reschedule_workouts!, if: -> { saved_change_to_schedule? }

    # TODO: more flexible scheduling
    def schedule!(workout_plan)
      workout_plans.maximum(:planned_date).tap do |last_workout|
        last_workout_date = last_workout || Date.current
        candidates = schedule.map { |day| last_workout_date.next_occurring(day.to_sym) }
        workout_plan.planned_date = candidates.min_by { |date| (date - Date.current).abs }
      end

      workout_plan.save!
    end

    def reschedule_workouts!
      transaction do
        ordered_plans = workout_plans.order(:planned_date).to_a
        workout_plans.update_all(planned_date: nil)

        ordered_plans.each do |plan|
          schedule!(plan.reload)
        end
      end
    end

    private

    def schedule_workouts
      workout_plans.each do |plan|
        schedule!(plan)
      end
    end
  end
end
