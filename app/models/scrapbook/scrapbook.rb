# frozen_string_literal: true

module Scrapbook
  # Modeling the scrap book
  class Scrapbook
    attr_accessor :root

    def self.find_scrapbook_for(pathname)
      scrapbooks = ::Scrapbook::Engine.config.scrapbook.paths
      candidates = scrapbooks.each_with_index.filter_map do |pname, index|
        relative_path = pathname.relative_path_from(pname)
        next if relative_path.to_s.start_with?('..')

        [index, relative_path.each_filename.count]
      end

      new(scrapbooks[candidates.min_by { _1[1] }.first])
    end

    def initialize(root)
      self.root = Pathname.new(root)
    end

    def pages_pathname
      root.join('pages')
    end

    def relative_page_path_for(pathname)
      return '' if pathname == pages_pathname

      relative_path = pathname.relative_path_from(pages_pathname).to_s
      if relative_path.start_with?('..')
        raise ArgumentError, "Pathname isn't inside the scrapbook pages: #{relative_path}"
      end

      relative_path
    end

    def ==(other)
      other.class == self.class && other.root == root
    end
    alias eql? ==
  end
end
