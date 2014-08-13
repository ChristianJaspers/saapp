module Comfy::Cms::SiteExt
  extend ActiveSupport::Concern

  included do
  end

  def root_page
    @root_page ||= pages.find_by(slug: 'index')
  end

  def static_pages
    if root_page
      root_page.children.published.includes(:site).all
    else
      []
    end
  end
end
