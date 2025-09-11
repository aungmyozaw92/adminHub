module ApplicationHelper
  def toast_classes(type)
    case type.to_s
    when 'success'
      'bg-green-500'
    when 'error'
      'bg-red-500'
    when 'warning'
      'bg-yellow-500'
    when 'info'
      'bg-blue-500'
    else
      'bg-gray-500'
    end
  end

  def toast_color(type)
    case type.to_s
    when 'success'
      'green'
    when 'error'
      'red'
    when 'warning'
      'yellow'
    when 'info'
      'blue'
    else
      'gray'
    end
  end

  def toast_icon(type)
    case type.to_s
    when 'success'
      content_tag(:svg, class: "h-6 w-6 text-white", fill: "none", viewBox: "0 0 24 24", stroke: "currentColor") do
        content_tag(:path, "", stroke_linecap: "round", stroke_linejoin: "round", stroke_width: "2", d: "M5 13l4 4L19 7")
      end
    when 'error'
      content_tag(:svg, class: "h-6 w-6 text-white", fill: "none", viewBox: "0 0 24 24", stroke: "currentColor") do
        content_tag(:path, "", stroke_linecap: "round", stroke_linejoin: "round", stroke_width: "2", d: "M6 18L18 6M6 6l12 12")
      end
    when 'warning'
      content_tag(:svg, class: "h-6 w-6 text-white", fill: "none", viewBox: "0 0 24 24", stroke: "currentColor") do
        content_tag(:path, "", stroke_linecap: "round", stroke_linejoin: "round", stroke_width: "2", d: "M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.732-.833-2.5 0L4.268 19.5c-.77.833.192 2.5 1.732 2.5z")
      end
    when 'info'
      content_tag(:svg, class: "h-6 w-6 text-white", fill: "none", viewBox: "0 0 24 24", stroke: "currentColor") do
        content_tag(:path, "", stroke_linecap: "round", stroke_linejoin: "round", stroke_width: "2", d: "M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z")
      end
    else
      content_tag(:svg, class: "h-6 w-6 text-white", fill: "none", viewBox: "0 0 24 24", stroke: "currentColor") do
        content_tag(:path, "", stroke_linecap: "round", stroke_linejoin: "round", stroke_width: "2", d: "M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z")
      end
    end
  end

  # Permission helper methods
  def can?(permission)
    current_user&.can?(permission)
  end

  def has_role?(role_name)
    current_user&.has_role?(role_name)
  end

  def admin?
    current_user&.admin?
  end

  def manager?
    current_user&.manager?
  end
end
