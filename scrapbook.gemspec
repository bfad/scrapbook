# frozen_string_literal: true

require_relative 'lib/scrapbook/version'

Gem::Specification.new do |spec|
  spec.name        = 'scrapbook'
  spec.version     = Scrapbook::VERSION
  spec.authors     = ['Brad Lindsay']
  spec.email       = ['sluggy.fan@gmail.com']
  spec.homepage    = 'https://bfad.github.io/scrapbook'
  spec.summary     = 'A place to document and test view helpers for Ruby on Rails'
  spec.description = 'Scrapbook allows you to collect and document complex view helpers or partials.'
  spec.license     = 'Apache-2.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/bfad/scrapbook'
  spec.metadata['changelog_uri'] = 'https://github.com/bfad/scrapbook/blob/main/CHANGELOG.md'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib,vendor}/**/*', 'LICENSE.txt', 'Rakefile', 'README.md']
  end

  spec.required_ruby_version = '>= 2.7.0'
  spec.add_dependency 'rails', '>= 6.1', '< 8.1'
end
