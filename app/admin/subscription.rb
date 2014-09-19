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
    column :created_at
    column :updated_at
    column :ends_at
    column :send_reminder_at
    actions
  end
end
