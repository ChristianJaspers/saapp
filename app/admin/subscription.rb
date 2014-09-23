ActiveAdmin.register Subscription do
  actions :index, :show

  index do
    selectable_column
    id_column
    column :reference
    column :company
    column :referrer
    column :quantity
    column :status
    column :ends_at
    column :is_test
    column :created_at
    column :updated_at
    column :send_reminder_at
    actions
  end
end
