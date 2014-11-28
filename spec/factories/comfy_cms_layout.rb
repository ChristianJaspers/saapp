FactoryGirl.define do
  factory :comfy_cms_layout, class: Comfy::Cms::Layout do
    site { create(:comfy_cms_site) }
    app_layout 'application'
    label 'Homepage layout'
    sequence(:identifier) { |x| "layout-#{x}" }
    content ''
    css ''
    js ''
    position 1
    is_shared false
  end
end
