# frozen_string_literal: true

module Scrapbook
  # View helpers for use in Scrapbook pages. All the methods are defined in the
  # `HelperForTemplateView` class while here we only define one method to namespace all of
  # them. This helps to avoid any conflicts with the host app.
  module PagesHelper
    def sb
      @_sb ||= HelperForTemplateView.new(self, controller.send(:scrapbook), controller.send(:pathname))
    end
  end
end
