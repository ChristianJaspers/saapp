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

      def footer_snippet_content(identifier)
        footer_snippets.detect { |snippet| snippet.identifier == identifier.to_s }.try(:content)
      end

      def footer_snippets
        @footer_snippets ||= snippets.where(identifier: ['footer_column_1', 'footer_column_2', 'footer_column_3']).all
      end
    end
  end
end
