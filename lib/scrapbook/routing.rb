# frozen_string_literal: true

module Scrapbook
  # This is a helper method for making it easier to add scrapbooks to routes.
  module Routing
    def scrapbook(name, at: "/#{name}", folder_root: name)
      folder_root = Pathname.new(folder_root)
      folder_root = Rails.root.join(folder_root) if folder_root.relative?

      Engine.config.scrapbook.paths[name] = folder_root
      mount Engine => at, defaults: {'.book': name}, as: "#{name}_scrapbook"
    end
  end
end
