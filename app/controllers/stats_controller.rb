class StatsController < ApplicationController
  TDEE_PERIOD = 49

  def index
    stats = Stats.stats(@current_user, last: params[:last]&.to_i)

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
