# frozen_string_literal: true

module Scrapbook
  # Model to assest list a folder's contents
  class FolderListingViewModel
    attr_reader :view, :scrapbook, :pathname, :files, :folders, :depth

    def initialize(view, scrapbook, pathname)
      self.view = view
      self.scrapbook = scrapbook
      self.pathname = pathname.directory? ? pathname : pathname.dirname
      self.depth = calculate_depth
      self.folders, self.files = split_files_and_folders
    end

    def root?
      pathname == scrapbook.pages_pathname
    end

    def parent_display_name
      return nil if root?
      return scrapbook.name if pathname.parent == scrapbook.pages_pathname

      pathname.parent.basename.to_s
    end

    def header_name
      root? ? scrapbook.name : pathname.basename.to_s
    end

    private

    attr_writer :view, :scrapbook, :pathname, :files, :folders, :depth

    def calculate_depth
      return 0 if pathname == scrapbook.pages_pathname

      scrapbook.relative_page_pathname_for(pathname).descend.count
    end

    def split_files_and_folders
      helper = HelperForNavView.new(view)

      folders, files = pathname.children.each_with_object([[], []]) do |pname, acc|
        next if pname.basename.to_s.start_with?('.')

        if pname.directory?
          acc[0] << pname
        else
          acc[1] << helper.remove_handler_exts_from(pname)
        end
      end

      folders.sort! { |a, b| a.to_s.downcase <=> b.to_s.downcase }
      files.sort! { |a, b| a.to_s.downcase <=> b.to_s.downcase }

      [folders, files]
    end
  end
end
