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

  shared_examples 'requires "template" or "partial" named parameter and the file to exist' do
    it 'fails without passing either template or partial' do
      expect { sb.render_source }.to raise_error(ArgumentError, /Missing named parameter/)
    end

    it 'fails if passed both template and partial' do
      expect { sb.render_source(partial: '', template: '') }
        .to raise_error(ArgumentError, /Can only pass one/)
    end

    it 'fails if the passed partial does not exist' do
      expect { sb.render_source(partial: 'components/austen') }
        .to raise_error(ActionView::MissingTemplate)
    end

    it 'fails if the passed template does not exist' do
      expect { sb.render_source(template: 'components/partiality') }
        .to raise_error(ActionView::MissingTemplate)
    end
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

    it_behaves_like 'requires "template" or "partial" named parameter and the file to exist'
  end

  describe '#render_with_source' do
    it "renders a template's source code followed by rendering the template itself" do
      source = File.read(PathnameHelpers.new.pages_pathname.join('components/austen.html.slim'))
      expect(sb.render_with_source(template: 'components/austen'))
        .to eql(
          "<pre><code>#{source}</code></pre><div><h1>Universal truth</h1>" \
          '<p>Single person with a large fortune seeks a marriage partner.</p></div>'
        )
    end

    it "renders a partial's source code followed by rendering the partial itself" do
      source = File.read(PathnameHelpers.new.pages_pathname.join('components/_partiality.html.slim'))
      expect(sb.render_with_source(partial: 'components/partiality'))
        .to eql("<pre><code>#{source}</code></pre><div><p>I am partial to pecan pie!</p></div>")
    end

    it_behaves_like 'requires "template" or "partial" named parameter and the file to exist'

    context 'when passed local variables' do
      it 'passes the locals to the template' do
        source = File.read(PathnameHelpers.new.pages_pathname.join('beta/locals.html.slim'))
        expect(sb.render_with_source(template: 'beta/locals', locals: {name: 'World!'}))
          .to eql("<pre><code>#{ERB::Util.html_escape_once(source)}</code></pre><div><p>Hello, World!</p></div>")
      end

      it 'passes the locals to the partial' do
        source = File.read(PathnameHelpers.new.pages_pathname.join('beta/_locals.html.slim'))
        expect(sb.render_with_source(partial: 'beta/locals', locals: {x: 'a', y: 'b'}))
          .to eql("<pre><code>#{source}</code></pre><div><ul><li>a</li><li>b</li></ul></div>")
      end
    end
  end
end
