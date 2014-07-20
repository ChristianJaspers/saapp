namespace :cms do
  desc 'Creates initial CMS data'
  task setup: :environment do
    cms = Comfy::Cms
    unless cms::Site.exists?
      site = cms::Site.create!(identifier: 'site-en', hostname: 'localhost', is_mirrored: true, locale: 'en')
      ENV['FROM'] = 'site-en'
      ENV['TO']   = 'site-en'
      Rake::Task['comfortable_mexican_sofa:fixtures:import'].invoke
    end
  end
end
