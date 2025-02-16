class Fitness::ExerciseTag < ApplicationRecord
  belongs_to :tag
  belongs_to :exercise, class_name: "Fitness::Exercise"

  validates_uniqueness_of :tag_id, scope: :exercise_id
end
