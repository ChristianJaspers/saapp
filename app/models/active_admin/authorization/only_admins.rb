module ActiveAdmin
  module Authorization
    class OnlyAdmins < ActiveAdmin::AuthorizationAdapter
      def authorized?(action, subject = nil)
        return is_cms_editor? if access_to_seo?(action, subject)

        case subject
          when ActiveAdmin::Page
            if subject.name == 'CMS' || subject.name == 'Dashboard'
              is_cms_editor?
            else
              is_admin?
            end
        else
          is_admin?
        end
      end

      private

      def access_to_seo?(action, subject)
        subject == Comfy::Cms::Site || subject == Comfy::Cms::Page || subject.is_a?(Comfy::Cms::Page)
      end

      def is_admin?
        user.admin?
      end

      def is_cms_editor?
         is_admin? || user.cms_editor?
      end
    end
  end
end
