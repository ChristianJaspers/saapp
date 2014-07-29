namespace :delayed_removal do
  desc 'Removes permanently outdated, removed objects'

  task perform: :environment do
    [Category, User].each do |klass|
      klass.purge_outdated_entries!
    end
  end
end
