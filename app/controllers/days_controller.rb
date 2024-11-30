require "csv"

class DaysController < ApplicationController
  before_action :set_day, only: [ :edit, :update ]

  def index
    @date = params[:date]&.to_date || Time.current.to_date
    @day = Day.find_or_initialize_by(
      date: @date
    )
    @show_points = true

    stats = Stats.stats(@current_user, start_date: @date.advance(days: -45), end_date: @date)

    @weight = stats.weight
    @kilocalories = stats.kilocalories
    @tdee = stats.tdee
    @ema = stats.ema
  end

  def new
    @day = Day.new(date: params[:date])
  end

  def create
    @day = @current_user.days.build(**day_params)

    if @day.save
      respond_to do |format|
        format.html { redirect_to(root_path, flash: { success: "day was successfully created." }) }
        format.turbo_stream do
          flash.now[:success] = "day was successfully created."
          render turbo_stream: turbo_stream.update("flash-container", partial: "layouts/flash")
        end
      end
    else
      flash.now[:danger] = @day.errors
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @day.update(day_params)
      respond_to do |format|
        format.html { redirect_to(root_path, flash: { success: "day was successfully updated." }) }
        format.turbo_stream do
          flash.now[:success] ="day was successfully updated."
          render turbo_stream: turbo_stream.update("flash-container", partial: "layouts/flash")
        end
      end
    else
      flash.now[:danger] = @day.errors
      render :new, status: :unprocessable_entity
    end
  end

  def by_date
    @day = @current_user.days.find_by(date: params[:date])

    if @day.nil?
      redirect_to(new_day_path(date: params[:date]))
    else
      redirect_to(edit_day_path(@day))
    end
  end

  private

  def set_day
    @day = @current_user.days.find(params[:id])
  end

  def day_params
    params.require(:day).permit(:kilocalories, :weight, :date)
  end
end
