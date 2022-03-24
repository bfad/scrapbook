# frozen_string_literal: true

module Scrapbook
  # TODO: Document this controller
  # Placeholder
  class PagesController < ApplicationController
    def index
      return head(:not_found) if (scrapbook = find_scrapbook).nil?
      return head(:not_found) if (pathname = find_folder_for(scrapbook, params[:path])).nil?

      render locals: {scrapbook: scrapbook, pathname: pathname}
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

    def find_folder_for(scrapbook, path)
      pathname = if path.present?
        scrapbook.pages_pathname.join(path)
      else
        scrapbook.pages_pathname
      end

      File.directory?(pathname) ? pathname : nil
    end
  end
end
