# frozen_string_literal: true

module Scrapbook
  # Engine-wide helpers
  module ApplicationHelper
    # Using `include Rails.application.helpers` didn't work for reloading changes
    # made to the main app's helper methods, but this is adapted from its code.
    # (I think it's getting around the memoized "@helpers" variable.)
    # https://github.com/rails/rails/blob/6bfc637659248df5d6719a86d2981b52662d9b50/railties/lib/rails/engine.rb#L494
    ActionController::Base.modules_for_helpers(
      ActionController::Base.all_helpers_from_path(Rails.application.helpers_paths)
    ).each { include _1 }
  end
end
