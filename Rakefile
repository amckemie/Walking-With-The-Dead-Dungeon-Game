require 'active_record_tasks'

ActiveRecordTasks.configure do |config|
  # These are all the default values
  config.db_dir = 'db'
  config.db_config_path = 'db/config.yml'
  config.env = 'development'
end

# Run this AFTER you've configured
ActiveRecordTasks.load_tasks

Rake::Task["db:seed"].clear

namespace :db do
  task :seed do
    require './db/seeds.rb'
  end
end

namespace :game do
  task :start => ["db:drop", "db:create", "db:migrate", "db:seed"] do
    puts "Database set up!"
  end
end
