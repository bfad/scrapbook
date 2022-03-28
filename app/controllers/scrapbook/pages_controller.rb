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
      template = Pathname.new(params[:id].delete_suffix('.html'))
      append_view_path(scrapbook.pages_pathname)

      if template_exists?(template)
        render template: template, locals: {scrapbook: scrapbook, pathname: pathname}, layout: !params[:raw]
      elsif pathname.directory?
        render 'scrapbook/pages/index', locals: {scrapbook: scrapbook, pathname: pathname}, layout: !params[:raw]
      elsif pathname.exist? && params[:raw]
        render file: pathname
      elsif pathname.exist?
        render locals: {scrapbook: scrapbook, pathname: pathname}, formats: [:html]
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
  end
end
