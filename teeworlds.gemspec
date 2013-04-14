# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'teeworlds/version'

Gem::Specification.new do |spec|
  spec.name          = "teeworlds"
  spec.version       = Teeworlds::VERSION
  spec.authors       = ["Maciej Borosiewicz"]
  spec.email         = ["m.borosiewicz@gmail.com"]
  spec.description   = %q{Teeworlds is a multiplayer shooter. This gem allows you to fetch all available game servers and view current status of each.}
  spec.summary       = %q{Classes to parse Teeworlds servers.}
  spec.homepage      = "https://github.com/xmbr/teeworlds"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", "~> 2.13"
  spec.add_development_dependency "rake"
end
