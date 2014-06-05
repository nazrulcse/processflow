module SettingsHelper

  def get_bgcolor
    @bgcolor = current_user.settings.find_by_key('bgcolor')
    @bgcolor.value
  end
end
