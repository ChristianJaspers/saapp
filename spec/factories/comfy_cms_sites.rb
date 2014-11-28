FactoryGirl.define do
  factory :comfy_cms_site, class: Comfy::Cms::Site do
    sequence(:identifier) { |x| "site-#{x}" }
    label 'Site EN'
    sequence(:hostname) { |x| "test#{x}.dev" }
    path ''
    locale 'en'
    is_mirrored true
  end
end
