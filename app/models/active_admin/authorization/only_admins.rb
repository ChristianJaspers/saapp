module ActiveAdmin
  module Authorization
    class OnlyAdmins < ActiveAdmin::AuthorizationAdapter
      def authorized?(action, subject = nil)
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

      def is_admin?
        user.admin?
      end

      def is_cms_editor?
         is_admin? || user.cms_editor?
      end
    end
  end
end
