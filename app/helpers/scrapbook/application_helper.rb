# frozen_string_literal: true

module Scrapbook
  # Engine-wide helpers
  module ApplicationHelper
    include Rails.application.helpers

    def short_path_to(pathname, scrapbook = nil)
      scrapbook ||= Scrapbook.find_scrapbook_for(pathname)

      short_page_path(scrapbook.relative_page_path_for(pathname)).gsub(/%2F/i, '/')
    end

    def pathname_without_handler_exts(pathname)
      pathname.dirname.join(
        pathname.basename.sub(/(?:.#{lookup_context.handlers.join('|.')})+\z/, '')
      )
    end
  end
end
