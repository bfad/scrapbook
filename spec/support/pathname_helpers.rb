# frozen_string_literal: true

class PathnameHelpers
  BOXCAR_RAILS_ROOT = Pathname.new("#{__dir__}/../../test/boxcar").expand_path

  attr_accessor :rails_root

  def initialize(rails_root = BOXCAR_RAILS_ROOT)
    self.rails_root = rails_root
  end

  def scrapbook_root(relative_path = 'scrapbook')
    rails_root.join(relative_path)
  end

  def pages_pathname(scrapbook_root_pathname = scrapbook_root)
    scrapbook_root_pathname.join('pages')
  end
end
