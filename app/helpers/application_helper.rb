module ApplicationHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def generate_graph(project)
    return "#{project.name} #{image_tag('graph.png')}".html_safe
  end

  def is_project_owner!(project)
    return project.owner_id == current_user.id ? true : false
  end

  def get_owner
    return current_user.email
  end

  def get_image(user_id)
    @user = User.find_by_id(user_id)
    if(@user.image?)
      @user.image_url(:small_thumb)
    else
      '/assets/default_user_icon.png'
    end
  end

  def get_reply_div
    content_tag :div, class: 'write-reply' do
      text_area_tag(:comment_reply, nil, :class => 'reply_input jqte-test') # Note the + in this line
      submit_tag(:Save, :class => 'btn')
    end
  end

  def is_read(notification)
   NotificationSubcription.read_info(notification).present?
  end

end
