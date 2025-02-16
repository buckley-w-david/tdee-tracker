module Fitness
  class Exercise < ApplicationRecord
    has_many :exercise_tags, dependent: :destroy, class_name: "Fitness::ExerciseTag"

    enum :warmup_strategy, { dumbbell: "dumbbell", barbell: "barbell" }

    accepts_nested_attributes_for :exercise_tags, allow_destroy: true
    # TODO: add warmup set calculator
    #       Examples strategies:
    #       https://warmupcalculator.com/ "Default"
    #         warmupPercentages = [0.4, 0.6, 0.7, 1];
    #         reps = [10, 6, 3];
    #       https://www.reddit.com/r/powerlifting/comments/7jsra4/how_do_you_calculate_warmup_and_working_weights/drb5bkm/
    #         10 reps with bar
    #         5 Reps at 65% of planned working Weight
    #         3 Reps at 80% of planned working weight
    #         1 Rep at 90% of working weight
    #         1 Rep at 95% of working weight
    #       https://www.ironsidetraining.com/blog/how-to-warm-up-for-your-working-sets
    #         Warm-up set 1: Start with the empty bar and warm up for a few reps there.
    #         Warm-Up Set 2: 40-50% of your first set x 5 reps (if the empty bar falls into this percentage- skip this step).
    #         Warm-Up Set 3: 60-65% of your first set x 3-5 reps
    #         Warm-Up Set 4: 70-80% of your first set x 3 reps
    #         Warm-up set 5: 85-90% of your first set x 1-3 reps
    #         Warm-Up Set 6: 90-95% of your first set x 1-3 reps
    #         Start working sets!
    #       https://www.baystrength.com/calculating-warmup-sets/
    #         2 sets of 5 with the empty bar and then 3 additional warmup sets with increasing weight on the bar provide an adequate warmup
    #         At the very beginning of a lifter’s linear progression, I will often have them do a set of 5 for every warmup set except for the last one, where I have them do a set of 2.
    #         method 1: even jumps - take your work weight of the day, subtract the bar (45 lbs), and then divide the difference by 4
    #         method 2: (empty bar /) 45% / 65% / 85% (/ work weight)
    #
    # TODO: How to figure out different warmup strategies depending on exercise?
    # exercise tags are still TODO, but could be used to determine warmup strategy
    # Could also just have an explicit warmup strategy enum

    # TODO: More sophisticated warmup calculator
    def warmup_sets(work_weight, round_to: 5)
      case warmup_strategy
      when "dumbbell"
        [
          [ 5, round_to_nearest(work_weight * 0.6, round_to) ]
        ]
      when "barbell"
        [
          [ 10, round_to_nearest(work_weight * 0.4, round_to) ],
          [ 6, round_to_nearest(work_weight * 0.6, round_to) ],
          [ 3, round_to_nearest(work_weight * 0.7, round_to) ]
        ]
      end
    end

    private

    def round_to_nearest(value, round_to)
      (value / round_to).ceil * round_to
    end
  end
end
