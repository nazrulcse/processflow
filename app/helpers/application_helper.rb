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

end
