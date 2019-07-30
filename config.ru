ROOT_PATH = File.dirname(__FILE__)
$LOAD_PATH.unshift(ROOT_PATH)
$LOAD_PATH.unshift(File.join(ROOT_PATH, 'lib'))

require 'system/boot'
Dir[File.join(__dir__, 'lib', '*.rb')].each { |file| require file }
require File.expand_path("../web",  __FILE__)

run Web
