db_tasks = %w[db:migrate db:rollback db:schema:load]

namespace :reload_views do
  db_tasks.each do |task_name|
    task task_name => %w[environment db:load_config] do
      ActiveRecord::DatabaseViews.reload!
    end
  end
end

db_tasks.each do |task_name|
  Rake::Task[task_name].enhance do
    Rake::Task["reload_views:#{task_name}"].invoke
  end
end
