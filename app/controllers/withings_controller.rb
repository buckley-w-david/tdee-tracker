class WithingsController < ApplicationController
  def register
    RegisterWithingsJob.perform_later(@current_user.id, params[:code], params[:state])

    redirect_to(root_path, flash: { success: "Connceted to Withings API" })
  end
end
