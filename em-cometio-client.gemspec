# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'em-cometio-client/version'

Gem::Specification.new do |gem|
  gem.name          = "em-cometio-client"
  gem.version       = EventMachine::CometIO::Client::VERSION
  gem.authors       = ["Sho Hashimoto"]
  gem.email         = ["hashimoto@shokai.org"]
  gem.description   = %q{sinatra-cometio client for eventmachine}
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/shokai/em-cometio-client"

  gem.files         = `git ls-files`.split($/).reject{|i| i=="Gemfile.lock" }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency 'eventmachine'
  gem.add_dependency 'em-http-request'
  gem.add_dependency 'json'
  gem.add_dependency 'event_emitter', '>= 0.2.0'
end
