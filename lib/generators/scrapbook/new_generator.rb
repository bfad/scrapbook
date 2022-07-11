# frozen_string_literal: true

require 'rails/generators'

module Scrapbook
  # A generator to create a new scrapbook at either the default (scrapbook) or specified
  # path from the Rails application root.
  class NewGenerator < Rails::Generators::Base
    argument :name, optional: true, default: 'scrapbook'

    def new
      create_file("#{name}/pages/.keep")

      # TODO: Investigate using hooks to default to ERB, but allow templates to overwrite
      create_file("#{name}/pages.html.erb",
        <<~HTML
          <h1>Welcome to Scrapbook</h1>
          <p>Feel free to customize this page and add more folders and pages to your Scrapbook</p>
        HTML
      )
    end
  end
end
