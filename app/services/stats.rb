module Stats extend self
  TDEE_PERIOD = 49

  class Result
    attr_reader :tdee, :weight, :kilocalories, :ema

    def initialize(weight, kilocalories, ema, tdee)
      @weight = weight
      @kilocalories = kilocalories
      @ema = ema
      @tdee = tdee
    end
  end

  def stats(user, start_date: Time.current.advance(days: -TDEE_PERIOD).to_date, end_date: Time.current.to_date)
    # This implementation fills in gaps in weight measurement with a straight line approximation between the start and end of the gap
    days = []
    all_days = user.days.order(:date).pluck(:date, :weight, :kilocalories).index_by { |d| d[0] }
    days_with_weights = all_days.filter { |d, (_, w, k)| w }.values
    days_with_weights.each_cons(2) do |d, n|
      if d[0].tomorrow != n[0]
        delta_days = (n[0]- d[0]).to_i
        delta_weight = n[1] - d[1]
        delta_days.times do |i|
          date = d[0].advance(days: i)
          days << [
            date,
            d[1] + (delta_weight / delta_days)*i,
            all_days[date][2]
          ]
        end
      else
        days << d
      end
    end
    days << days_with_weights.last

    # This implementation fills in gaps in kilocalorie measurement with a 14 day average centered on the day
    # This still isn't great, since if we're missing a lot of days in a row they'll get overwhelmed by present
    # data at the fringes, but meh, this is an edge case anyway
    days.each_cons(15) do |days|
      next if days[7][2]

      k = days.filter { |d, w, k| k }
      avg = k.sum / k.length

      days[7][2] = avg
    end

    # This will miss days at the beginning and end, we just do a dumb average for anything else
    cal = days.filter_map { |_, w, k| k }
    total_average = cal.sum / cal.length
    days.each do |d|
      d[2] = total_average if d[2].nil?
    end
    days[-1][2] = nil # Kilocalories for the last day are undetermined (in progress), we don't want our estimate

    # At this point, days is now a continious range of days with both kilocalorie info and weight info for every day
    # That makes further calculation much easier

    weight = days.map { |w| [ w[0], w[1] ] }

    x = []
    y = []
    calorie_window = []
    linefit = LineFit.new

    tdee = days.each_with_index.filter_map do |day, i|
      y << day[1]
      x << i
      calorie_window << day[2]

      next unless i >= TDEE_PERIOD

      # By using the calorie window _before_ the oldest one is removed
      # and going to the -2 index, it is offset by a day, which is what we want
      # since the TDEE for a day is based on calories from _bofore_ that day (not on that day)
      calories = calorie_window[..-2].sum / calorie_window[..-2].length

      calorie_window.shift
      x.shift
      y.shift

      linefit.setData(x, y)
      _, slope = linefit.coefficients

      # FIXME: 3500kcal = 1lbs of fat loss is an outdated rule of thumb
      #        https://pmc.ncbi.nlm.nih.gov/articles/PMC4035446/
      [ day[0], (calories - 3500*slope).to_f ]
    end

    kilocalories = days.map { |d| [ d[0], d[2] ] }

    ema = TechnicalAnalysis::Ema.calculate(weight.map { |d, t| { date_time: d, value: t } }, period: 14).map do |ema|
      [ ema.date_time, ema.ema ]
    end.to_h

    # We do a full history calculation and then remove data we don't need
    # This may seem wasteful, but it makes everything _much_ easier because
    # the EMA and TDEE calculations depend on data outside our range
    ema.filter! { |date, _| (start_date.nil? || date >= start_date) && (end_date.nil? || date <= end_date) }
    weight.filter! { |date, _| (start_date.nil? || date >= start_date) && (end_date.nil? || date <= end_date) }
    kilocalories.filter! { |date, _| (start_date.nil? || date >= start_date) && (end_date.nil? || date <= end_date) }
    tdee.filter! { |date, _| (start_date.nil? || date >= start_date) && (end_date.nil? || date <= end_date) }

    Result.new(weight, kilocalories, ema, tdee)
  end

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
