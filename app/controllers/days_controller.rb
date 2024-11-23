require "csv"


class DaysController < ApplicationController
  before_action :set_day, only: [ :edit, :update ]

  def index
    @date = Time.current.to_date
    @day = Day.find_or_initialize_by(
      date: @date
    )

    stats = Stats.stats(@current_user, last: 45)

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

  def import_stats
    file = File.open(params[:file])
    format = params[:date_format] || "%m/%d/%Y"

    CSV.foreach(file, headers: true) do |row|
      next if row["Weight"].blank? && row["Kilocalories"].blank?

      day = @current_user.days.find_or_initialize_by(date: Date.strptime(row["Date"], format))

      unless row["Weight"].blank?
        day.weight = row["Weight"].to_f
      end

      unless row["Kilocalories"].blank?
        day.kilocalories = row["Kilocalories"].to_i
      end

      day.save
    end
  end

  def import_loseit
    file = File.open(params[:file])
    blob = ActiveStorage::Blob.create_and_upload!(io: file, filename: SecureRandom.uuid)

    Import::LoseitEntriesJob.perform_later(@current_user.id, blob.id)

    redirect_to(root_path, flash: { success: "Importing LoseIt entries" })
  end

  private

  def set_day
    @day = @current_user.days.find(params[:id])
  end

  def day_params
    params.require(:day).permit(:kilocalories, :weight, :date)
  end
end
