Dir[File.join(__dir__, 'lib', '*.rb')].each { |file| require file }
require File.expand_path("../app",  __FILE__)
run App.app
