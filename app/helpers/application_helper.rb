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

end
