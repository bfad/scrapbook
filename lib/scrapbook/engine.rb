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
        app.config.assets.precompile.concat %w[
          scrapbook/application.css
        ]
      end
    end

    # From: turbo-rails
    initializer 'turbo.mimetype' do
      Mime::Type.register 'text/vnd.turbo-stream.html', :turbo_stream
    end
  end
end
