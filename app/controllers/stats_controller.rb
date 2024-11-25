class StatsController < ApplicationController
  TDEE_PERIOD = 49

  def index
    start_date = Time.current.advance(days: -params[:last].to_i).to_date if params[:last].present?
    end_date = Time.current.to_date
    stats = Stats.stats(@current_user, start_date:, end_date:)

    @weight = stats.weight
    @kilocalories = stats.kilocalories
    @tdee = stats.tdee
    @ema = stats.ema

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("stats", partial: "days/stats")
      end
    end
  end
end
