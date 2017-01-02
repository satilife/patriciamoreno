module LabelHelper
  def yes_label(inverse=false)
    content_tag(:span, 'Yes', class: "label label-#{inverse ? 'danger' : 'success'}")
  end

  def no_label(inverse=false)
    content_tag(:span, 'No', class: "label label-#{inverse ? 'success' : 'danger'}")
  end

  def yes_no_label(bool, inverse=false)
    bool ? yes_label(inverse) : no_label(inverse)
  end

  def default_label
    content_tag(:span, 'Default', class: 'label label-info')
  end
end
