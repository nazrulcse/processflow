module SettingsHelper

  def get_bgcolor
    if !current_user.present?
      return "EEE"
    end
    @bgcolor = current_user.settings.find_by_key('bgcolor')
    if(@bgcolor.nil?)
      "EEE"
    else
      @bgcolor.value
    end
  end
end
