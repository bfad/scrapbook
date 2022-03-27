# frozen_string_literal: true

module Scrapbook
  # Engine-wide helpers
  module ApplicationHelper
    include Rails.application.helpers

    def short_link_to_folder(pathname, scrapbook = nil)
      link_to "#{pathname.basename}/", short_path_to(pathname, scrapbook)
    end

    def short_link_to_file(pathname, scrapbook = nil)
      formatted_basename = pathname.basename.sub(/(?:.#{lookup_context.handlers.join('|.')})+\z/, '')
      formatted_pathname = pathname.dirname.join(formatted_basename)
      link_to formatted_basename, short_path_to(formatted_pathname, scrapbook)
    end

    private

    def short_path_to(pathname, scrapbook = nil)
      scrapbook ||= Scrapbook.find_scrapbook_for(pathname)

      short_page_path(scrapbook.relative_page_path_for(pathname)).gsub(/%2F/i, '/')
    end
  end
end
