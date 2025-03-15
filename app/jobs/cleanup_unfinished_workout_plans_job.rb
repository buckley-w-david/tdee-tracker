class CleanupUnfinishedWorkoutPlansJob < ApplicationJob
  queue_as :default

  def perform
    Fitness::Routine.joins(:workout_plans).where("planned_date < ?", Date.today).each do |routine|
      routine.reschedule_workouts!
    end
  end
end
