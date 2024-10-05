require "csv"

class AdminController < ApplicationController
  def import_foods
    if params[:file].nil?
      redirect_to root_url, alert: "No file selected."
      return
    end

    records = CSV.foreach(params[:file].path, headers: true).map do |row|
      row.to_h.slice("name", "quantity", "unit", "kilocalories")
    end

    Food.insert_all(records)

    redirect_to root_url, notice: "Foods imported"
  end
end
