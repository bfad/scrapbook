# frozen_string_literal: true

require 'rails_helper'
require 'active_record'

RSpec.describe Scrapbook::Scrapbook do
  subject(:scrapbook) { described_class.new(PathnameHelpers.new.scrapbook_root) }

  describe '.find_scrapbook_for' do
    subject(:found) { described_class.find_scrapbook_for(pathname) }

    let(:pathname) { PathnameHelpers.new.pages_pathname.join('components/folder_name/with_panache.html.erb') }

    it { is_expected.to eql(scrapbook) }

    context 'when pathname is inside nested scrapbooks' do
      let(:base_pathname) { PathnameHelpers.new.scrapbook_root }
      let(:nested_pathname) { base_pathname.join('pages/wandering/nested/new_book') }
      let(:pathname) { nested_pathname.join('pages/far/and/wide.html.haml') }

      before do
        allow(Scrapbook::Engine.config.scrapbook).to receive(:paths)
          .and_return({'book1' => base_pathname, 'nested' => nested_pathname})
      end

      it { is_expected.to eql(described_class.new(nested_pathname)) }
    end

    context "when pathname isn't in a scrapbook" do
      let(:pathname) { Rails.root.join('app/views/stuff.html.slim') }

      it { will_be_expected.to raise_error(described_class::NotFoundError) }
    end
  end

  describe '#name' do
    subject { scrapbook.name }

    it { is_expected.to eql(scrapbook.root.basename.to_s) }
  end

  describe '#pages_pathname' do
    subject { scrapbook.pages_pathname }

    it { is_expected.to eql(scrapbook.root.join('pages')) }
  end

  describe '#relative_page_path_for' do
    it 'returns a path without the absolute path to the scrapbook' do
      relative_path = 'components/folder_name.html.erb'
      pathname = scrapbook.pages_pathname.join(relative_path)

      expect(scrapbook.relative_page_path_for(pathname)).to eql(relative_path)
    end

    context 'when the pathname is the scrapbook pages path' do
      it 'returns an empty string' do
        pathname = scrapbook.pages_pathname

        expect(scrapbook.relative_page_path_for(pathname)).to eql('')
      end
    end

    context 'when the pathname is not a descendent of the pages path of the scrapbook' do
      it 'raises an error' do
        pathname = Rails.root.join('app')

        expect { scrapbook.relative_page_path_for(pathname) }
          .to raise_error(ArgumentError, /#{pathname.relative_path_from(scrapbook.pages_pathname)}/)
      end
    end
  end

  describe '#==' do
    it 'returns true when roots of two objects are the same' do
      scrapbook1 = described_class.new(PathnameHelpers.new.scrapbook_root)
      scrapbook2 = described_class.new(PathnameHelpers.new.scrapbook_root)
      expect(scrapbook1 == scrapbook2).to be true
    end

    it 'returns false when roots of two objects are different' do
      scrapbook1 = described_class.new(PathnameHelpers.new.scrapbook_root)
      scrapbook2 = described_class.new(Rails.root.join('app'))
      expect(scrapbook1 == scrapbook2).to be false
    end
  end
end
