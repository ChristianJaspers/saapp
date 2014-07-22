namespace :delayed_removal do
  desc 'Removes permanently outdated, removed objects'

  task perform: :environment do
    Category.purge_outdated_entries!
  end
end
