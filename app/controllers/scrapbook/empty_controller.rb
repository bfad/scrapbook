# frozen_string_literal: true

module Scrapbook
  # This controller is used to specify view paths to check if a template exists.
  class EmptyController < ApplicationController
    self.view_paths = []
  end
  private_constant :EmptyController
end
