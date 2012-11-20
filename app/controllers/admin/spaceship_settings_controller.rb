class Admin::SpaceshipSettingsController < AdminController
  authorize_resource

  def index
    @settings = SpaceshipSetting.order(:id).all
  end

  def update
    setting = SpaceshipSetting.find(params[:id])
    if setting.update_attributes(params[:spaceship_setting])
      redirect_to admin_spaceship_settings_path
    end
  end
end