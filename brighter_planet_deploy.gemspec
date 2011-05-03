# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "brighter_planet_deploy/version"

Gem::Specification.new do |s|
  s.name        = "brighter_planet_deploy"
  s.version     = BrighterPlanet::Deploy::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["TODO: Write your name"]
  s.email       = ["TODO: Write your email address"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "brighter_planet_deploy"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_development_dependency 'test-unit'
  s.add_development_dependency 'fakeweb'
  s.add_development_dependency 'fakefs'
  s.add_dependency 'activesupport', '>= 2.3.11'
  s.add_dependency 'i18n' # for activesupport
  s.add_dependency 'eat'
end
