ActiveAdmin.setup do |config|
  config.namespace :admin do |admin|
    admin.build_menu do |menu|
      menu.add label: 'CMS', url: '/admin/cms', html_options: {target: :blank}
    end
  end
end
