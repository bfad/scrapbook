# frozen_string_literal: true

module Scrapbook
  # @todo Document this controller
  # Handles requests for specific pages — either a full page load, or Turbo Drive request
  # for navigation.
  # Handles requests to display a specifc page — both for the Scrapbook application itself
  # and the content within the user's Scrapbook.
  class PagesController < ApplicationController
    self.view_paths = Engine.config.paths['app/views'].to_a

    layout -> { false if request.headers.include?('Turbo-Frame') }

    # Displays the requested page for both full page loads, or Turbo Drive requests from
    # page navigation.
    def show
      return head(:not_found) if scrapbook.nil?

      if request.headers['Turbo-Frame']&.start_with?('path_')
        render partial: 'layouts/scrapbook/folder_listing',
          locals: {scrapbook: scrapbook, pathname: pathname}
      else
        render locals: {scrapbook: scrapbook, pathname: pathname}, formats: [:html]
      end
    end

    # Handles translating the path to look up and generate the content from the Scrapbook.
    # The content could be a template page, a template for a directory, the default content
    # for directories without associated content pages, or just a raw file (like an image).
    def raw
      return head(:not_found) if scrapbook.nil?

      if scrapbook_template_exists?(scrapbook, template)
        prepend_view_path(scrapbook.root)
        render template: template,
          # DEPRECATED: The locals "scrapbook" and "pathname". Use `sb.scrapbook` and `sb.pathname` instead.
          locals: {scrapbook: scrapbook, pathname: pathname},
          layout: 'layouts/scrapbook/host_application'
      elsif pathname.directory?
        render '/pages',
          # DEPRECATED: The locals "scrapbook" and "pathname". Use `sb.scrapbook` and `sb.pathname` instead.
          locals: {scrapbook: scrapbook, pathname: pathname},
          layout: 'layouts/scrapbook/host_application'
      elsif pathname.exist?
        render file: pathname
      else
        head :not_found
      end
    end

    private

    def scrapbook
      return @scrapbook if defined?(@scrapbook)

      @scrapbook = if book_name.blank?
        nil
      else
        scrapbook_path = Engine.config.scrapbook.paths[book_name]
        scrapbook_path && Scrapbook.new(scrapbook_path)
      end
    end

    def pathname
      return @pathname if defined?(@pathname)

      @pathname = scrapbook.pages_pathname.join(params[:id] || '')
    end

    def template
      return @template if defined?(@template)

      @template = if params[:id].blank?
        'pages'
      else
        "pages/#{params[:id].delete_suffix('.html')}"
      end
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
