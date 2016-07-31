class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
   protect_from_forgery with: :exception
   before_filter :configure_permitted_parameters, if: :devise_controller?
   helper_method :day_remaining_status

   def authenticate_user
     if (!current_user.present?)
       flash[:error] = 'Please sign to continue'
       redirect_to root_path()
     end
   end

   def after_sign_in_path_for(resource)
     projects_path()
   end

   def process_flow
     Pubnub.new(
         :publish_key => 'pub-c-c4cb0923-f0e6-43cf-b514-86be9bf01cea',
         :subscribe_key => 'sub-c-6386dc38-0034-11e4-b698-02ee2ddab7fe',
         :secret_key => 'sec-c-Yzc1NTIxMjktMDg5Ny00NzYzLTgxNjUtMzEzOWQ2NDg5OGZi',
         :error_callback   => lambda { |msg|
           puts "Error callback says: #{msg.inspect}"
         },
         :connect_callback => lambda { |msg|
           puts "CONNECTED: #{msg.inspect}"
         },
         :ssl => false
     )
   end

   def day_remaining_status(task)
     if(task.end_date?)
       today_time = Date.parse(task.end_date.to_s).to_time.to_i
       end_time = Date.today.to_time.to_i
       remaining_day = (today_time - end_time).to_i / 86400
       if(remaining_day == 1)
         return 'finish_tomorrow'
       elsif(remaining_day == 0)
         return 'finish_today'
       elsif(remaining_day < 0)
         return 'time_past'
       else
         return 'upcoming'
       end
     end
   end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:name, :zip, :email, :image, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:name, :country, :zip, :username, :image, :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.permit(:sign_in) do |u|
      u.permit(:username, :email, :password)
    end
  end

end
