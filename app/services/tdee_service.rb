require "line_fit"

class TdeeService
  class << self
    def calculate(day)
      user = day.user
      end_date = day.date
      start_date = end_date - 49.days # TODO: Don't hardcode this

      # We go back 1 day for the start and end because the calories on day n affects the weight on day n+1
      calories = user.days.where(date: (start_date - 1.days)..(end_date - 1.days)).average(:kilocalories)

      x = []
      y = []

      # TODO: Validate that this range has the right inclusivity on the end points
      records = user.days.where(date: start_date..end_date).order(:date)
      records.each do |day|
        next unless day.weight

        y << day.weight
        x << (day.date - start_date).to_i
      end

      linefit = LineFit.new
      linefit.setData(x, y)
      _, slope = linefit.coefficients

      return nil if slope.nil? || calories.nil?

      # TODO: If I ever introduce configurable weight units, this will need to adjust for the correct conversion factor
      #       lbs is 3500
      (calories - 3500*slope).to_f
    end
  end
end
