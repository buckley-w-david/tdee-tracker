module Stats extend self
  def weight_ema(days, period: 30)
    weight = days
      .where.not(weight: nil)
      .order(date: :asc)
      .pluck(:date, :weight)

    ema = TechnicalAnalysis::Ema.calculate(weight.map { |d, t| { date_time: d, value: t } }, period:).map do |ema|
      [ ema.date_time, ema.ema ]
    end.to_h

    [ weight, ema ]
  rescue TechnicalAnalysis::Validation::ValidationError => e
    [ weight, {} ]
  end
end
