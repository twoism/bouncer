# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bouncer/version"

Gem::Specification.new do |s|
  s.name        = "bouncer"
  s.version     = Bouncer::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["twoism"]
  s.email       = ["signalstatic@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/bouncer"
  s.summary     = %q{simple authorization}
  s.description = %q{simplest authoization}

  s.rubyforge_project = "bouncer"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
