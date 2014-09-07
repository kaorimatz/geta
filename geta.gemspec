lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'geta/version'

Gem::Specification.new do |spec|
  spec.name          = 'geta'
  spec.version       = Geta::VERSION
  spec.authors       = ['Satoshi Matsumoto']
  spec.email         = ['kaorimatz@gmail.com']
  spec.summary       = %q{Create the cobbler system record for your existing linux system based on the information collected through SSH.}
  spec.description   = %q{Create the cobbler system record for your existing linux system based on the information collected through SSH.}
  spec.homepage      = 'https://github.com/kaorimatz/geta'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'net-ssh'
  spec.add_dependency 'slop'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'simplecov'
end
