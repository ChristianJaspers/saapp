FactoryGirl.define do
  factory :cms_page_seo_data, class: CmsPageSeoData do
    page_id { create(:comfy_cms_page).id }
  end
end
