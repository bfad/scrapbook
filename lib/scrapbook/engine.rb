# frozen_string_literal: true

module Scrapbook
  # :nodoc:
  class Engine < ::Rails::Engine
    isolate_namespace Scrapbook

    config.scrapbook = ActiveSupport::OrderedOptions.new
    config.scrapbook.paths ||= []
    config.scrapbook.precompile_assets = config.scrapbook.precompile_assets || false

    initializer 'scrapbook.configuration' do |app|
      settings = app.config.scrapbook

      settings.paths << Rails.root.join('scrapbook') if settings.paths.empty?
    end

    initializer 'scrapbook.assets' do |app|
      if app.config.scrapbook.precompile_assets && app.config.respond_to?(:assets)
        app.config.assets.precompile.concat %w[
          scrapbook/tailwind_preflight_reset.css
          scrapbook/tailwind.css
        ]
      end
    end
  end
end
