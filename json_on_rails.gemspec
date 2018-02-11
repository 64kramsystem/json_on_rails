# frozen_string_literal: true

lib_dir = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require "json_on_rails/version"

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "json_on_rails"
  s.version     = JsonOnRails::VERSION
  s.summary     = "MySQL JSON support for Rails 4"
  s.description = "Add native support for MySQL [5.7] JSON data type to Rails 4."
  s.date        = "2018-02-10"

  s.required_ruby_version = ">= 2.1.0"

  s.license = "GPL-3.0"

  s.author   = "Saverio Miroddi"
  s.email    = "saverio.pub2@gmail.com"
  s.homepage = "https://github.com/saveriomiroddi/json_on_rails"

  s.files        = Dir["LICENSE", "README.md", "lib/**/*"]
  s.require_path = "lib"

  s.add_runtime_dependency "activerecord", "~> 4.0"
  s.add_runtime_dependency "mysql2", "~> 0.4"

  s.add_development_dependency "coveralls", "~> 0.8.21"
  s.add_development_dependency "rake", "~> 12.3"
  s.add_development_dependency "rspec", "~> 3.7"
  s.add_development_dependency "rspec-rails", "~> 3.7"
end
