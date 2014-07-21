namespace :cms do
  desc 'Creates initial CMS data'
  task setup: :environment do
    unless Comfy::Cms::Site.exists?
      site = Comfy::Cms::Site.create!(identifier: 'site-en', hostname: 'localhost', is_mirrored: true, locale: 'en')
      ENV['FROM'] = 'site-en'
      ENV['TO']   = 'site-en'
      Rake::Task['comfortable_mexican_sofa:fixtures:import'].invoke
    end
  end
end
