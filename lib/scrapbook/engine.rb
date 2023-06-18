# frozen_string_literal: true

module Scrapbook
  # :nodoc:
  class Engine < ::Rails::Engine
    isolate_namespace Scrapbook

    config.scrapbook = ActiveSupport::OrderedOptions.new
    config.scrapbook.paths ||= {}
    config.scrapbook.precompile_assets = config.scrapbook.precompile_assets || false

    initializer 'scrapbook.assets' do |app|
      if app.config.scrapbook.precompile_assets && app.config.respond_to?(:assets)
        app.config.assets.precompile.push('scrapbook/application.css')
      end
    end
  end
end
