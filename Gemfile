source :rubygems
gem 'mongoid'
gem 'bson_ext'
gem 'bcrypt-ruby'
gem 'tilt'
gem 'slim'

# our .gemspec
gemspec

group :development do
  gem 'irbtools'
end

group :test do
  gem 'guard-minitest'
  platforms :ruby_19 do
    gem 'ruby-debug19'
  end
end
