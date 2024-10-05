require "line_fit"

class FancyTdeeService
  class << self
    def calculate(day, period: 14)
      user = day.user
      end_date = day.date
      start_date = end_date - period.days

      # We go back 1 day for the start and end because the calories on day n affects the weight on day n+1
      calories = user.days.where(date: (start_date - 1.days)..(end_date - 1.days)).average(:kilocalories)

      x = []
      y = []

      weight = user.days
        .where.not(weight: nil)
        .order(date: :asc)
        .pluck(:date, :weight)

      ema = TechnicalAnalysis::Ema.calculate(weight.map { |d, t| { date_time: d, value: t } }, period:).each do |ema|
        next if ema.date_time < start_date
        y << ema.ema
        x << (ema.date_time - start_date).to_i
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
