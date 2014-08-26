namespace :cms do
  desc 'Creates initial CMS data'
  task setup: :environment do
    unless Comfy::Cms::Site.exists?
      sites_data = [
        {
          locale: 'en',
          path: ''
        },
        {
          locale: 'da',
          path: 'da'
        }
      ].each do |site_params|
        site_id = "site-#{site_params[:locale]}"
        site = Comfy::Cms::Site.create!(identifier: site_id, hostname: ENV['HOST'] || 'localhost:3000', is_mirrored: true, locale: site_params[:locale], path: site_params[:path])
        ENV['FROM'] = site_id
        ENV['TO']   = site_id
        Rake::Task['comfortable_mexican_sofa:fixtures:import'].reenable
        Rake::Task['comfortable_mexican_sofa:fixtures:import'].invoke
      end
    end
  end
end
