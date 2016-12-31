module ApplicationHelper
  def active_for(controller)
    'active' if controller_name == controller
  end

  def hide_for(controller)
    'hide' if controller_name == controller
  end
end
