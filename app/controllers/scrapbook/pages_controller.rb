# frozen_string_literal: true

module Scrapbook
  # @todo Document this controller
  class PagesController < ApplicationController
    self.view_paths = Engine.config.paths['app/views'].to_a

    def index
      return head(:not_found) if (scrapbook = find_scrapbook).nil?
      return head(:not_found) unless (pathname = calculate_pathname(scrapbook, params[:path])).directory?

      if pathname == scrapbook.pages_pathname
        prepend_view_path(scrapbook.root)
        render template: 'pages', locals: {scrapbook: scrapbook, pathname: pathname}
      else
        render locals: {scrapbook: scrapbook, pathname: pathname}
      end
    end

    def show
      return head(:not_found) if (scrapbook = find_scrapbook).nil?

      pathname = calculate_pathname(scrapbook, params[:id])
      template = params[:id].delete_suffix('.html')

      if !scrapbook_template_exists?(scrapbook, template) && pathname.directory?
        render 'scrapbook/pages/index', locals: {scrapbook: scrapbook, pathname: pathname}
      else
        render locals: {scrapbook: scrapbook, pathname: pathname}, formats: [:html]
      end
    end

    def raw
      return head(:not_found) if (scrapbook = find_scrapbook).nil?

      pathname = calculate_pathname(scrapbook, params[:id])
      template = params[:id].delete_suffix('.html')

      if scrapbook_template_exists?(scrapbook, template)
        prepend_view_path(scrapbook.pages_pathname)
        render template: template,
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
      scrapbook_path = if params[:book].present?
        ::Scrapbook::Engine.config.scrapbook.paths.find { File.basename(_1) == params[:book] }
      else
        ::Scrapbook::Engine.config.scrapbook.paths.first
      end

      scrapbook_path && Scrapbook.new(scrapbook_path)
    end

    def calculate_pathname(scrapbook, path)
      if path.present?
        scrapbook.pages_pathname.join(path)
      else
        scrapbook.pages_pathname
      end
    end

    def scrapbook_template_exists?(scrapbook, template)
      # It's deprecated, but Rails 6 allows for templates to be specified with extensions.
      return false if Rails.version.to_i == 6 && template.include?('.')

      EmptyController.new.tap { |c| c.prepend_view_path(scrapbook.pages_pathname) }.template_exists?(template)
    end
  end
end
