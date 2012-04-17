require 'mongoid'
require 'mongoid_models/models/document'
require 'mongoid_models/models/user'
require 'bcrypt'

def irb_helper
  require 'ruby-debug'
  ENV['RACK_ENV'] = 'production'
  require 'mongoid_models'
  include MongoidModels
  Mongoid.load!("test/mongoid.yml")
end
