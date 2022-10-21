# frozen_string_literal: true

module Scrapbook
  # @todo Document this controller
  class PagesController < ApplicationController
    self.view_paths = Engine.config.paths['app/views'].to_a

    def show
      return head(:not_found) if (scrapbook = find_scrapbook).nil?

      pathname = calculate_pathname(scrapbook, params[:id])
      render locals: {scrapbook: scrapbook, pathname: pathname}, formats: [:html]
    end

    def raw
      return head(:not_found) if (scrapbook = find_scrapbook).nil?

      pathname = calculate_pathname(scrapbook, params[:id])
      template = calculate_template

      if scrapbook_template_exists?(scrapbook, template)
        prepend_view_path(scrapbook.root)
        render template: template,
          locals: {scrapbook: scrapbook, pathname: pathname},
          layout: 'layouts/scrapbook/host_application'
      elsif pathname.directory?
        render '/pages',
          locals: {scrapbook: scrapbook, pathname: pathname},
          layout: 'layouts/scrapbook/host_application'
      elsif pathname.exist?
        render file: pathname
      else
        head :not_found
      end
    end

    private

    def find_scrapbook
      return nil if book_name.blank?

      scrapbook_path = Engine.config.scrapbook.paths[book_name]
      scrapbook_path && Scrapbook.new(scrapbook_path)
    end

    def calculate_pathname(scrapbook, path)
      scrapbook.pages_pathname.join(path || '')
    end

    def calculate_template
      return 'pages' if params[:id].blank?

      "pages/#{params[:id].delete_suffix('.html')}"
    end

    def scrapbook_template_exists?(scrapbook, template)
      # It's deprecated, but Rails 6 allows for templates to be specified with extensions.
      return false if Rails.version.to_i == 6 && template.include?('.')

      EmptyController.new.tap { |c| c.prepend_view_path(scrapbook.root) }.template_exists?(template)
    end

    def book_name
      params[:'.book']
    end
  end
end
