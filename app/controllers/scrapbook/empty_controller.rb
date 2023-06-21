# frozen_string_literal: true

module Scrapbook
  # This controller is used to specify view paths to check if a template exists.
  #
  # Scapbook views (Rails templates) exist outside the normal Rails views hierarchy. This is
  # fine, we can prepend the view path for Scrapbook pages to our controller when we need to
  # render Scrapbook pages. However, part of the process for to determine if we need to
  # render a Scrapbook page is determining if the template exists. We want to know if the
  # template exists before we prepend the path to the controller and render it. This empty
  # controller allows us to call `EmptyController#template_exists?` to do just that after we
  # prepend the view path to it.
  class EmptyController < ApplicationController
    self.view_paths = []
  end
  private_constant :EmptyController
end
