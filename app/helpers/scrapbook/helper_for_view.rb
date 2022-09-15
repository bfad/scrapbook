# frozen_string_literal: true

module Scrapbook
  # View helpers for the Scrapbook gem. Doesn't use standard Rail's helper
  # modules to avoid any conflicts with host app
  class HelperForView
    def initialize(view)
      self.view = view
    end

    def short_path_to(pathname, scrapbook = nil)
      scrapbook ||= Scrapbook.find_scrapbook_for(pathname)
      view.short_page_path(scrapbook.relative_page_path_for(pathname))
    end

    def remove_handler_exts_from(pathname)
      pathname.dirname.join(
        pathname.basename.sub(/(?:.#{view.lookup_context.handlers.join('|.')})+\z/, '')
      )
    end

    private

    attr_accessor :view
  end
end
