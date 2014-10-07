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

  def javascript_google_plus_for_mobile_site(request)
    if request && is_mobile_site?(request)
      raw %{<script type="text/javascript" async defer src="https://apis.google.com/js/platform.js?publisherid=117891000421394623155"></script>}
    end
  end

  def is_mobile_site?(request)
    # http://detectmobilebrowsers.com/
    if request.user_agent
      /(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino/i.match(request.user_agent) || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.match(request.user_agent[0..3])
    end
  end
end
