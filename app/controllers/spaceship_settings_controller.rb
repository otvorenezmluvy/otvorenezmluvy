class SpaceshipSettingsController < AuthorizedController
  before_filter :set_body_class

  def index
    @settings = SpaceshipSetting.all
  end

  def update
    setting = SpaceshipSetting.find(params[:id])
    if setting.update_attributes(params[:spaceship_setting])
      redirect_to spaceship_settings_path
    else
    end
  end

  private
  def set_body_class
    @body_class = "detail"
  end
end