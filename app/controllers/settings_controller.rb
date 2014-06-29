class SettingsController < ApplicationController
  before_action :set_setting, only: [:update]

  def index
    @settings = Setting.all
  end

  def create
    @settings = current_user.settings.find_by_key(params[:key])
    if @settings.present?
      @result = @settings.update_attributes(:value => params[:value])
    else
      @new_settings = current_user.settings.build(:key => params[:key], :value => params[:value])
      @result = @new_settings.save()
    end
    respond_to do |format|
      if @result
        format.js { render :layout => false }
      end
    end
  end

  def update
    respond_to do |format|
      if @setting.update(setting_params)
        format.html { redirect_to @setting, notice: 'Setting was successfully updated.' }
        format.json { render :show, status: :ok, location: @setting }
      else
        format.html { render :edit }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_setting
    @setting = Setting.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def setting_params
    params.require(:setting).permit(:user_id, :key, :value)
  end
end
