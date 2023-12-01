# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scrapbook::HelperForTemplateView do
  subject(:sb) { described_class.new(helper, scrapbook, pathname) }

  let(:scrapbook) { Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root) }
  let(:pathname) { PathnameHelpers.new.pages_pathname.join('components') }

  before do
    # The pages controller adds this when rendering Scrapbook pages
    helper.controller.prepend_view_path(scrapbook.root)
  end

  describe '#render_source' do
    it "renders a template's source code" do
      source = File.read(PathnameHelpers.new.pages_pathname.join('components/austen.html.slim'))
      expect(sb.render_source(template: 'components/austen'))
        .to eql("<pre><code>#{source}</code></pre>")
    end

    it "renders a partial's source code" do
      source = File.read(PathnameHelpers.new.pages_pathname.join('components/_partiality.html.slim'))
      expect(sb.render_source(partial: 'components/partiality'))
        .to eql("<pre><code>#{source}</code></pre>")
    end

    it 'fails if the passed partial does not exist' do
      expect { sb.render_source(partial: 'components/austen') }
        .to raise_error(ActionView::MissingTemplate)
    end

    it 'fails if the passed template does not exist' do
      expect { sb.render_source(template: 'components/partiality') }
        .to raise_error(ActionView::MissingTemplate)
    end

    it 'fails without passing either template or partial' do
      expect { sb.render_source }.to raise_error(ArgumentError, /Missing named parameter/)
    end

    it 'fails if passed both template and partial' do
      expect { sb.render_source(partial: '', template: '') }
        .to raise_error(ArgumentError, /Can only pass one/)
    end
  end
end
