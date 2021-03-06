# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'thredded_create_app/version'

Gem::Specification.new do |s|
  s.name          = 'thredded_create_app'
  s.version       = ThreddedCreateApp::VERSION
  s.authors       = ['Gleb Mazovetskiy']
  s.email         = ['glex.spb@gmail.com']

  s.summary       = 'Rails app generator for Thredded.'
  s.description   = 'Generates a Rails app with Thredded installed.'
  s.homepage      = 'https://github.com/thredded/thredded_create_app'
  s.license       = 'MIT'

  s.required_ruby_version = '~> 2.5'

  s.files = Dir['{exe,lib}/**/*'] + %w[LICENSE.txt README.md]

  s.bindir        = 'exe'
  s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'highline', '>= 1.7.2'
  s.add_dependency 'rainbow', '>= 3.0.0', '< 4'
  s.add_development_dependency 'bundler', '~> 2.0'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 3.9'
  s.add_development_dependency 'simplecov'
end
