# frozen_string_literal: true

require 'rails/generators'

module Scrapbook
  # Initial default setup of Scrapbook
  class InstallGenerator < Rails::Generators::Base
    class_option 'url-path', default: '/scrapbook'
    class_option 'path-with-name', default: 'scrapbook'

    def install
      generate 'scrapbook:routes', options.fetch('url-path')
      generate 'scrapbook:new', options.fetch('path-with-name')
      sprockets_support
    end

    private

    def sprockets_support
      relative_path = 'app/assets/config/manifest.js'
      return unless FileTest.exist?(File.expand_path(relative_path, destination_root))

      insert_into_file(relative_path, '//= link scrapbook/application.css')
    end
  end
end
