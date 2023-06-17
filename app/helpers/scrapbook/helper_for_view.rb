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

    def nav_link_for(scrapbook:, pathname:, is_current: false, depth: 0, **kwargs)
      link_name = pathname == scrapbook.pages_pathname ? scrapbook.name : pathname.basename
      link_attrs = {
        data: {'turbo-frame': 'page_content'},
        class: %w[block w-100],
        aria: {}
      }
      link_attrs[:style] = "padding-left: #{depth}rem;" if depth != 0
      link_attrs[:aria][:current] = 'page' if is_current
      link_attrs[:class].concat(Array(kwargs.delete(:class))) if kwargs.include?(:class)
      link_attrs[:data].merge!(kwargs.delete(:data)) if kwargs.include?(:data)
      link_attrs[:aria].merge!(kwargs.delete(:aria)) if kwargs.include?(:aria)
      link_attrs.merge!(kwargs)

      view.link_to(link_name, short_path_to(pathname, scrapbook), **link_attrs)
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
