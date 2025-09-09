module Admin::UsersHelper
  def role_badge_class(role_name)
    case role_name.downcase
    when "admin"
      "bg-red-100 text-red-800"
    when "manager"
      "bg-yellow-100 text-yellow-800"
    when "moderator"
      "bg-purple-100 text-purple-800"
    when "user"
      "bg-green-100 text-green-800"
    else
      "bg-gray-100 text-gray-800"
    end
  end

  def user_avatar_tag(user, options = {})
    if user.avatar.attached?
      image_tag(user.avatar, options.merge(alt: user.name))
    else
      content_tag(:div, options.merge(class: "#{options[:class]} bg-blue-100 rounded-full flex items-center justify-center")) do
        content_tag(:span, user.name.split.map(&:first).join.upcase, class: "text-sm font-medium text-blue-600")
      end
    end
  end
end
