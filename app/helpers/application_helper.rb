module ApplicationHelper
  def flash_message_color(flash_key_name)
    if flash_key_name == 'warning'
      flash_key_name
    else
      ['error', 'alert'].include?(flash_key_name) ? 'danger' : 'success'
    end
  end

  def billing_link(user)
    "https://sites.fastspring.com/copenhagenapphouse/instant/bettersalesman?quantity=#{user.sales_reps_count}&referrer=#{user.id}"
  end

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

  def desktop_favicon_link_tag(size = nil)
    if size
      sizes = "#{size}x#{size}"
      favicon_link_tag("/favicon-#{sizes}.png", rel: 'icon', sizes: sizes, type: 'image/png')
    else
      favicon_link_tag("/favicon.ico", rel: 'icon', type: 'image/png')
    end
  end

  def apple_favicon_link_tag(size = nil)
    if size
      size = "#{size}x#{size}" if size.class == Fixnum
      generic_apple_favicon_link_tag("/apple-touch-icon-#{size}.png", sizes: size)
    else
      generic_apple_favicon_link_tag("/apple-touch-icon.png")
    end
  end

  def generic_apple_favicon_link_tag(path, options={})
    with_options(options) { |cfg| cfg.favicon_link_tag path, rel: 'apple-touch-icon', type: 'image/png' }
  end
end
