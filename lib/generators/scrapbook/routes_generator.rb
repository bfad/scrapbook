# frozen_string_literal: true

require 'rails/generators'

module Scrapbook
  # A generator to create a new scrapbook at either the default (scrapbook) or specified
  # path from the Rails application root.
  class RoutesGenerator < Rails::Generators::Base
    argument :path, optional: true, default: '/scrapbook'

    def routes
      # TODO: Investigate using a Rubocop rule to determine using single or double auotes.
      url_path = path.start_with?('/') ? path : "/#{path}"
      route <<~ROUTES
        if Rails.env.development?
          mount Scrapbook::Engine => '#{url_path}'
        end
      ROUTES
    end
  end
end
