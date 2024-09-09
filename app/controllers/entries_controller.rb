require 'csv'

class EntriesController < ApplicationController
  before_action :set_entry, only: [:edit, :update]

  def new
    @entry = Entry.new(date: params[:date])
  end

  def create
    @entry = @current_user.entries.build(**entry_params)

    if @entry.save
      respond_to do |format|
        format.html { redirect_to(root_path, flash: { success: "Entry was successfully created." }) }
        format.turbo_stream do
          flash.now[:success] = "Entry was successfully created."
          render turbo_stream: turbo_stream.update("flash-container", partial: "layouts/flash")
        end
      end
    else
      flash.now[:danger] = @entry.errors
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @entry.update(entry_params)
      respond_to do |format|
        format.html { redirect_to(root_path, flash: { success: "Entry was successfully updated." }) }
        format.turbo_stream do
          flash.now[:success] ="Entry was successfully updated."
          render turbo_stream: turbo_stream.update("flash-container", partial: "layouts/flash")
        end
      end
    else
      flash.now[:danger] = @entry.errors
      render :new, status: :unprocessable_entity
    end
  end

  def by_date
    @entry = @current_user.entries.find_by(date: params[:date])

    if @entry.nil?
      redirect_to(new_entry_path(date: params[:date]))
    else
      redirect_to(edit_entry_path(@entry))
    end
  end

  def import_values
    file = File.open(params[:file])
    format = params[:date_format] || "%m/%d/%Y"

    CSV.foreach(file, headers: true) do |row|
      next if row["Weight"].blank? && row["Kilocalories"].blank?

      entry = @current_user.entries.find_or_initialize_by(date: Date.strptime(row["Date"], format))

      unless row["Weight"].blank?
        entry.weight = row["Weight"].to_f
      end

      unless row["Kilocalories"].blank?
        entry.kilocalories = row["Kilocalories"].to_i
      end

      entry.save
    end
  end

  private

  def set_entry
    @entry = @current_user.entries.find(params[:id])
  end

  def entry_params
    params.require(:entry).permit(:kilocalories, :weight, :date)
  end
end
