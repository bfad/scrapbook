# frozen_string_literal: true

# Creates some helper matchers / methods to be used with controller tests.
#
# Adds the `render_with` matcher.
# Ex:
#   expect(controller).to render_with(template: :show, locals: { pathname: pages_pathname })
#
# Adds the `template_locals` method.
# This allows you to inspect the locals hash passed to `render` in a controller action.
# Ex:
#   # Call in controller: `render locals: { scrapbook: scrapbook, pathname: my_pathname }`
#   expect(template_locals[:scrapbook])).to eq(scrapbook)
#   expect(template_locals).to include(pathname: my_pathname)
#   expect(template_locals).to be_empty
module ControllerHelpers
  def self.included(base)
    # Setup spying for the "render_with" matcher & capture the locals for "template_locals".
    base.before do
      allow(controller).to receive(:render).and_wrap_original do |original, *args, **kwargs, &block|
        @_template_locals ||= kwargs[:locals]
        original.call(*args, **kwargs, &block)
      end
    end
  end

  RSpec::Matchers.define :render_with do |expected|
    match do |actual|
      have_received(:render).with(expected).matches?(actual)
    end
  end

  def template_locals
    @_template_locals
  end
end
