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
    "#{project.name} #{image_tag('graph.png')}".html_safe
  end

  def is_project_owner!(project)
    project.owner_id == current_user.id ? true : false
  end

  def get_owner
    current_user.email
  end

  def new_relation(task)
    Relation.new(:child => task.id, :project_id => task.project_id)
  end

  def user_avatar(user_id, version='small')
    @user = User.find_by_id(user_id)
    if @user.image.present? && @user.image.version_exists?(version)
      @user.image_url(version)
    else
      'default_user_icon.png'
    end
  end

  def count_notification(user_id, project_id)
    total_notification = NotificationSubcription.notification_count(project_id, user_id)
    total_notification > 0 ? total_notification : 0
  end

  def get_reply_div
    content_tag :div, class: 'write-reply' do
      text_area_tag(:comment_reply, nil, :class => 'reply_input jqte-test') # Note the + in this line
      submit_tag(:Save, :class => 'btn')
    end
  end

  def initialize_form(form, association, force = false)
    if form.object.new_record? || force
      form.object.class.reflect_on_association(association).klass.new
    else
      form
    end
  end

  def is_read(notification)
   NotificationSubcription.read_info(notification).present?
  end

end
