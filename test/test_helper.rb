ENV['RACK_ENV'] = "test"
require 'minitest/autorun'
require 'mongoid_models'
require 'tilt'
require 'slim'

if RUBY_VERSION >= "1.9.2"
  require 'ruby-debug'
end

Mongoid.load!("test/mongoid.yml")
