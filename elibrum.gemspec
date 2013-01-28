$:.push File.expand_path("../lib", __FILE__)
require "elibrum/version"

Gem::Specification.new do |s|
  s.name          = "elibrum"
  s.version       = Elibrum::VERSION
  s.authors       = ["Dave Sescleifer"]
  s.summary       = "Converts webpages into ebooks"
  s.description   = "Converts webpages into ebooks."
  s.email         = "dave@sescleifer.com"
  s.platform      = "java"
  s.homepage      = "http://github.com/dsesclei/elibrum"
  s.require_paths = ["lib"]
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.add_runtime_dependency "nokogiri", ["~> 1.5.6"]
  s.add_runtime_dependency "erubis", ["~> 2.7.0"]
end