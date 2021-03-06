# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 's3browser/version'

Gem::Specification.new do |spec|
  spec.name          = "s3browser"
  spec.version       = S3Browser::VERSION
  spec.authors       = ["Jurgens du Toit"]
  spec.email         = ["jrgns@jrgns.net"]

  spec.summary       = %q{A simple yet extendable utility to browse files on S3.}
  spec.description   = %q{A simple yet extendable utility to browse files on S3.}
  spec.homepage      = "https://github.com/jrgns/s3browser"
  spec.license       = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_dependency 'aws-sdk'
  spec.add_dependency 'elasticsearch'
  spec.add_dependency 'sinatra'
  spec.add_dependency 'rack-flash3'
  spec.add_dependency 'haml'
  spec.add_dependency 'highline'
  spec.add_dependency 'dotenv'
  spec.add_dependency 'shoryuken'
  spec.add_dependency 's3proxy'
end
