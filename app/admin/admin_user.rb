ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation

  actions :all, except: [:new]

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    column :remove_at
    column 'Autologin' do |user|
      if user.manager?
        link_to 'Login to user account', autologin_admin_user_path(user), method: :post
      end
    end
    actions
  end

  member_action :autologin, method: :post do
    token = Admin::Autologin.new(resource).perform

    if token
      redirect_to autologin_path(token)
    else
      redirect_to({action: :inedx}, {:notice => "Can not autologin"})
    end
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs "User details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  controller do
    def scoped_collection
      User.unscoped
    end
  end

  batch_action :destroy do |selection|
    User.unscoped.find(selection).each(&:destroy)
    redirect_to collection_path, :notice => "Users deleted"
  end
end
