FactoryGirl.define do
  factory :comfy_cms_page, class: Comfy::Cms::Page do
    layout { create(:comfy_cms_layout) }
    site { layout.site }
    parent_id nil
    target_page_id nil
    label 'Home'
    slug 'index'
    full_path '/'
    content_cache ''
    position 0
    children_count 0
    is_published true
    is_shared false
  end
end
