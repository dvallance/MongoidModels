#$:.push File.expand_path("../lib", __FILE__)
require "./lib/mongoid_models/version"

Gem::Specification.new do |s|
	s.name = "mongomatic_models"
	s.version = MongoidModels::VERSION
	s.required_rubygems_version = ">= 1.3.6"
	s.authors = ["David Vallance"]
	s.date = "2011-08-28"
	s.add_dependency("mongoid")
  s.add_dependency("bson_ext")
  s.add_dependency("bcrypt-ruby")
	#s.files = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md ROADMAP.md CHANGELOG.md)	
  s.files = 'git ls-files'.split("\n")
  s.test_files = 'git ls-files -- {test,spec,features}/*'
  s.require_paths = ["lib"]
end


