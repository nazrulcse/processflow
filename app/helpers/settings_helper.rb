module SettingsHelper

  def get_bgcolor
    if !current_user.present?
      return 'EEE'
    end
    @bgcolor = current_user.settings.find_by_key('bgcolor')
    if (@bgcolor.nil?)
      'EEE'
    else
      @bgcolor.value
    end
  end

  def get_navcolor
    if !current_user.present?
      return 'f8f8f8'
    end
    @bgcolor = current_user.settings.find_by_key('navcolor')
    if (@bgcolor.nil?)
      'f8f8f8'
    else
      @bgcolor.value
    end
  end

end
