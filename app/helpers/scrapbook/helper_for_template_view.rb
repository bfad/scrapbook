# frozen_string_literal: true

module Scrapbook
  # Implementation of methods that can be used in views by accessing the `sb` helper method.
  class HelperForTemplateView
    attr_reader :scrapbook, :pathname

    delegate :tag, to: :view

    def initialize(view, scrapbook, pathname)
      self.view = view
      self.scrapbook = scrapbook
      self.pathname = pathname
    end

    # Takes in a relative path to a scrapbook page and renders its source code. You specify
    # the path as either a "template" or "partial" path similarly to how you would render a
    # view in Rails. For example, `partial: "my/path/to/partial"` would look for a Scrapbook
    # page named something like "my/path/to/_partial.html.erb" in the view paths.
    #
    # @param template [String] the relative path to a Scrapbook page similar to the path you
    #   would give when rendering a Rails template. (Leave `nil` if specifying a partial.)
    # @param partial [String] the relative path to a Scrapbook page similar to the path you
    #   would give when rendering a Rails partial. (Leave `nil` if specifying a template.)
    # @return [String] the source code of a file wrapped in "<pre><code>" tags.
    def render_source(template: nil, partial: nil)
      raise ArgumentError, 'Missing named parameter of either "partial" or "template"' if partial.nil? && template.nil?
      raise ArgumentError, 'Can only pass one of either "partial" or "template"' if !partial.nil? && !template.nil?

      view_name = pathname.relative_path_from(scrapbook.root).dirname.join(partial || template).to_s
      tag.pre(tag.code(view.lookup_context.find(view_name, [], !partial.nil?).source))
    end

    # Takes in a relative path to a scrapbook page and renders its source code followed by
    # rendering the page itself. You specify the page as either a "template" or "partial"
    # path similarly to how you would render a view in Rails, and you can pass in `locals`
    # too.
    #
    # @param (see #render_source)
    # @param locals [Hash] a key-value hash whose keys are the names of locals to assign
    #   when the page is rendered.
    # @return [String] the source code of a file wrapped in "<pre><code>" tags followed by
    #   rendering the page itself wrapped in a "<div>".
    def render_with_source(template: nil, partial: nil, locals: {})
      # NOTE: Parameter validation of "template" and "partial" handled `render_source`.
      source = render_source(template: template, partial: partial)
      render_params = {locals: locals}
      render_params[partial.nil? ? :template : :partial] =
        pathname.relative_path_from(scrapbook.root).dirname.join(partial || template).to_s

      source + tag.div(view.render(**render_params))
    end

    private

    attr_accessor :view
    attr_writer :scrapbook, :pathname
  end
end
