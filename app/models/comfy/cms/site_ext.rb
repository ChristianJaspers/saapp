module Comfy
  module Cms
    module SiteExt
      extend ActiveSupport::Concern

      def root_page
        @root_page ||= pages.find_by(slug: 'index')
      end

      def root_page_content
        if root_page && root_page.is_published
          root_page.content_cache
        end
      end

      def static_pages
        if root_page
          root_page.children.published.includes(:site).all
        else
          []
        end
      end
    end
  end
end
