ActiveAdmin.register Company do
  menu parent: 'Debug', label: 'Unrated arguments per company'

  actions :index, :show

  controller do
    def scoped_collection
      Company.unscoped
    end
  end

  index do
    id_column
    column 'Managers' do |company|
      html = ''
      company.users.managers.each do |manager|
        html += manager.display_name.present? ? "#{manager.email} (#{manager.display_name})" : manager.email
      end
      html
    end
    column :created_at
    column :updated_at

    column do |company|
      html = ''.html_safe
      html += link_to(I18n.t('active_admin.view'), admin_all_arguments_per_users_path(company_id: company.id), class: 'member_link view_link')
      html
    end
  end
end
