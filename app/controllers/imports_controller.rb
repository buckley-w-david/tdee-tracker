class ImportsController < ApplicationController
  def create
    if params[:kind] == "weight" || params[:kind] == "kilocalories"
      import_stats
    elsif params[:kind] == "meals"
      import_loseit
    else
      flash.now[:error] = "Invalid import kind"
      return render(:new, status: :unprocessable_entity)
    end

    redirect_to(root_path, flash: { success: "Import started" })
  end

  def import_stats
    file = File.open(params[:file])
    format = params[:date_format] || "%m/%d/%Y"

    blob = ActiveStorage::Blob.create_and_upload!(io: file, filename: SecureRandom.uuid)

    Import::LoseItStatsJob.perform_later(@current_user.id, blob.id, format)
  end

  def import_loseit
    file = File.open(params[:file])
    blob = ActiveStorage::Blob.create_and_upload!(io: file, filename: SecureRandom.uuid)

    Import::LoseitEntriesJob.perform_later(@current_user.id, blob.id)
  end
end
