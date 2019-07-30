require 'system/container'
require 'yaml'
require 'rom'

Container.configure do |container|
  db_config = YAML.load_file('config/database.yml')
  config = ROM::Configuration.new(
    :sql,
    db_config['connection_url'],
    db_config['params']
  )
  rom = ROM.container(config)

  container.register(:rom) do
    rom
  end
end

Container.finalize
