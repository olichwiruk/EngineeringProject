ROOT_PATH = File.dirname(__FILE__)
LIB_PATH = File.join(ROOT_PATH, 'lib')
$LOAD_PATH.unshift(ROOT_PATH)
$LOAD_PATH.unshift(File.join(ROOT_PATH, 'lib'))

require 'yaml'
require 'rom'
require 'system/boot'
require File.expand_path("../web",  __FILE__)

run Web
