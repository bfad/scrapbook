# frozen_string_literal: true

module Scrapbook
  # :nodoc:
  class Engine < ::Rails::Engine
    isolate_namespace Scrapbook

    config.scrapbook = ActiveSupport::OrderedOptions.new
    config.scrapbook.paths ||= []

    initializer 'scrapbook.configuration' do |app|
      settings = app.config.scrapbook

      settings.paths << Rails.root.join('scrapbook') if settings.paths.empty?
    end
  end
end
