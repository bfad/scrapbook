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
    end
  end
end
