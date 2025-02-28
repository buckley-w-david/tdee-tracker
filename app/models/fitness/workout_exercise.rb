module Fitness
  class WorkoutExercise < ApplicationRecord
    belongs_to :workout, class_name: "Fitness::Workout"
    belongs_to :exercise, class_name: "Fitness::Exercise"

    has_many :sets, dependent: :destroy, class_name: "Fitness::Set"

    accepts_nested_attributes_for :sets, allow_destroy: true

    def completed?
      sets.all?(&:completed?)
    end

    def failed?
      sets.any?(&:failed?)
    end

    def dnf?
      !completed? && !failed?
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
