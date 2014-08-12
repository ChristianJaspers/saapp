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

  def submit_button_with_loader(content)
    content_tag :button, content, {type: :submit, class: 'btn btn-primary ladda-button', data: {style: 'zoom-out'}}
  end
end
