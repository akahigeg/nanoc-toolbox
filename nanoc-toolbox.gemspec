# -*- encoding: utf-8 -*-
require File.expand_path("../lib/nanoc/toolbox/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "nanoc-toolbox"
  s.version     = Nanoc::Toolbox::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Anouar ADLANI"]
  s.email       = ["anouar@adlani.com"]
  s.homepage    = "http://rubygems.org/gems/nanoc-tools"
  s.summary     = "A collection of helper and filters for nanoc"
  s.description = ""
  

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "nanoc-toolbox"

  s.add_dependency "nanoc", ">= 3.1.6"
  
  s.add_development_dependency "bundler", ">= 1.0.0"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
