# frozen_string_literal: true

module Scrapbook
  # Implementation of methods that can be used in views by accessing the `sb` helper method.
  class HelperForTemplateView
    attr_reader :scrapbook, :pathname

    def initialize(view, scrapbook, pathname)
      self.view = view
      self.scrapbook = scrapbook
      self.pathname = pathname
    end

    private

    attr_accessor :view
    attr_writer :scrapbook, :pathname
  end
end
