Dir[File.join(__dir__, 'lib', '*.rb')].each { |file| require file }
require File.expand_path("../app",  __FILE__)

require 'yaml'
require 'rom'
$config = ROM::Configuration.new(:sql, YAML.load_file('config/database.yml')['connection_url'])

run App.app
