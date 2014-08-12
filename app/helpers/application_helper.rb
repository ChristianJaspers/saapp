module ApplicationHelper
  def logged_in?
    current_user.present?
  end

  def guest?
    not logged_in?
  end

  def localized_cms_page_path(cms_page)
    "/#{cms_page.site.path}/#{cms_page.full_path}".squeeze("/")
  end

  def locale_flag_filename(locale)
    "locales/#{locale}.png"
  end

  def submit_button_with_loader(content, html_options = {})
    css_class = 'btn btn-primary ladda-button'
    html_options[:type] ||= :submit
    html_options[:data] ||= {}
    html_options[:data][:style] ||= 'zoom-out'
    html_options[:class] = html_options[:class] ? "#{css_class} #{html_options[:class]}" : css_class
    content_tag :button, content, html_options
  end
end
