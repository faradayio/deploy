# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "brighter_planet_deploy/version"

Gem::Specification.new do |s|
  s.name        = "brighter_planet_deploy"
  s.version     = BrighterPlanet::Deploy::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Seamus Abshere", "Andy Rossmeissl"]
  s.email       = ["seamus@abshere.net"]
  s.homepage    = ""
  s.summary     = %q{Brighter Planet deployment system, published as the gem brighter_planet_deploy}
  s.description = %q{Brighter Planet deployment system, published as the gem brighter_planet_deploy. Internal use.}

  s.rubyforge_project = "brighter_planet_deploy"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_development_dependency 'test-unit'
  s.add_development_dependency 'fakeweb'
  s.add_development_dependency 'fakefs'
  s.add_development_dependency 'net-dns'
  s.add_development_dependency 'activesupport'
  s.add_development_dependency 'i18n'
  s.add_development_dependency 'rake'
  s.add_dependency 'thor'
  s.add_dependency 'eat'
end
