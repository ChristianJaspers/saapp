ActiveAdmin.register Subscription do
  actions :index, :show, :edit

  index do
    selectable_column
    id_column
    column :reference
    column 'Managers' do |subscription|
      html = ''
      if subscription.company_with_deleted
        subscription.company_with_deleted.users.managers.order(:id).each do |manager|
          html += manager.display_name.present? ? "#{manager.email} (#{manager.display_name})" : manager.email
        end
      else
        html += 'Deleted'
      end
      html
    end
    column 'Company' do |subscription|
      "##{subscription.company_id}"
    end
    column :referrer_id
    column :quantity
    column :status
    column :ends_at
    column :is_test
    column :created_at
    column :updated_at
    column :send_reminder_at
    column do |subscription|
      html = ''.html_safe
      html += link_to(I18n.t('active_admin.view'), admin_subscription_path(subscription), class: 'member_link view_link')
      html += link_to(I18n.t('active_admin.edit'), edit_admin_subscription_path(subscription), class: 'member_link edit_link') if subscription.trial?
      html
    end
  end

  form do |f|
    f.inputs 'Subscription' do
      f.input :ends_at
    end
    f.actions
  end

  controller do
    def updater
      update = Admin::SubscriptionUpdater.new(resource, params)
      updater.save
      redirect_to action: :edit
    end
  end
end
