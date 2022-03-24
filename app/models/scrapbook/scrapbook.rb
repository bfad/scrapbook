# frozen_string_literal: true

module Scrapbook
  # Modeling the scrap book
  class Scrapbook
    attr_accessor :root

    def initialize(root)
      self.root = Pathname.new(root)
    end

    def pages_pathname
      root.join('pages')
    end

    def ==(other)
      other.class == self.class && other.root == root
    end
  end
end
