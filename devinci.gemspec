# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "devinci/version"

Gem::Specification.new do |s|
  s.name        = "devinci"
  s.version     = Devinci::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Paul Guelpa"]
  s.email       = ["paul.guelpa@gmail.com"]
  s.homepage    = "http://github.com/pguelpa/devinci"
  s.summary     = %q{Parser for various bike share data files}
  s.description = %q{Parses the data files supplied by a number of bike share systems}

  s.rubyforge_project = "devinci"

  s.add_dependency "libxml-ruby", ">= 1.1.3"
  s.add_dependency "nokogiri", ">= 1.5.0"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "rake", ">= 0.9.0"
  s.add_development_dependency "rcov", ">= 0.9.10"
  s.add_development_dependency "rspec", ">= 2.3.0"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
