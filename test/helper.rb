require 'rubygems'
require 'bundler'
Bundler.setup
require 'test/unit'
require 'fakefs/safe'
require 'fakeweb'
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'brighter_planet_deploy'
class Test::Unit::TestCase
end

require 'active_support/core_ext/module'
module Rails
  mattr_accessor :root, :env
end
