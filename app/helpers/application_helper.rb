module ApplicationHelper
  def active_for(controller)
    'active' if controller_name == controller
  end

  def active_for_subnav(type)
    'active' if subnav == type
  end

  def hide_for(controller)
    'hide' if controller_name == controller
  end
end
