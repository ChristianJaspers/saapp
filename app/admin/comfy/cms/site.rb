ActiveAdmin.register Comfy::Cms::Site do
  menu label: 'SEO'

  actions :index

  index do
    id_column
    column :identifier
    column :hostname
    column :locale
    column do |site|
      html = ''.html_safe
      html += link_to('View pages', admin_comfy_cms_pages_path(site_id: site.id), class: 'member_link view_link')
      html
    end
  end
end
