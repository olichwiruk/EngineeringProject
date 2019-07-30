require 'yaml'
require 'rom'
require 'rom/sql/rake_task'

namespace :db do
  task :setup do
    db_config = YAML.load_file('config/database.yml')
    ROM::SQL::RakeSupport.env = ROM.container(
      ROM::Configuration.new(
        :sql,
        db_config['connection_url'],
        db_config['params']
      )
    )
  end
end
