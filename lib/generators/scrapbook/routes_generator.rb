# frozen_string_literal: true

require 'rails/generators'

module Scrapbook
  # A generator to create a new scrapbook with  either the default (scrapbook) or specified
  # name. (Using the default options for the URL path and folder root.)
  class RoutesGenerator < Rails::Generators::Base
    argument :name, optional: true, default: 'scrapbook'

    def routes
      # TODO: Investigate using a Rubocop rule to determine using single or double auotes.

      inject_into_file('config/routes.rb', after: "Rails.application.routes.draw do\n") do
        "  extend Scrapbook::Routing\n"
      end

      inject_into_file('config/routes.rb', after: "extend Scrapbook::Routing\n") do
        "\n  scrapbook('#{name}') if Rails.env.development?\n"
      end
    end
  end
end
