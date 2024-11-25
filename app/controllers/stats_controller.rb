class StatsController < ApplicationController
  TDEE_PERIOD = 49

  def index
    start_date = params[:start_date]&.to_date
    end_date = params[:end_date]&.to_date || Time.current.to_date
    stats = Stats.stats(@current_user, start_date:, end_date:)

    @weight = stats.weight
    @kilocalories = stats.kilocalories
    @tdee = stats.tdee
    @ema = stats.ema

    if start_date && end_date
      @show_points = (end_date - start_date).to_i <= 100 # Arbitrary number
    else
      @show_points = (end_date - Day.minimum(:date)).to_i <= 100
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("stats", partial: "days/stats")
      end
    end
  end
end
