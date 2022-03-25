# frozen_string_literal: true

module Scrapbook
  # Engine-wide helpers
  module ApplicationHelper
    include Rails.application.helpers

    def short_link_to_folder(pathname, scrapbook = nil)
      link_to "#{pathname.basename}/", short_path_to(pathname, scrapbook)
    end

    def short_link_to_file(pathname, scrapbook = nil)
      noexts_pathname = pathname.dirname.join(pathname.basename.sub(/\..*\z/, ''))
      link_to noexts_pathname.basename, short_path_to(noexts_pathname, scrapbook)
    end

    private

    def short_path_to(pathname, scrapbook = nil)
      scrapbook ||= Scrapbook.find_scrapbook_for(pathname)

      short_page_path(scrapbook.relative_page_path_for(pathname)).gsub(/%2F/i, '/')
    end
  end
end
