# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_contexts/scrapcook'

RSpec.describe Scrapbook::HelperForView do
  describe '#short_path_to' do
    subject(:path) { described_class.new(helper).short_path_to(pathname, scrapbook) }

    let(:pathname) { PathnameHelpers.new.pages_pathname.join(relative_path) }
    let(:scrapbook) { nil }
    let(:relative_path) { 'components/folder_name/sub_stuff' }

    it 'returns a linkable path to the specified folder without the scrapbook prefix' do
      expect(path).to eql(helper.short_page_path(relative_path))
    end

    context 'when provided the scrapbook the folder belongs to' do
      let(:scrapbook) { Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root) }

      it 'returns a linkable path to the specified folder' do
        expect(path).to eql(helper.short_page_path(relative_path))
      end
    end

    context 'when the folder is not in the provided scrapbook' do
      let(:pathname) { Rails.root }
      let(:scrapbook) { Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root) }

      it { will_be_expected.to raise_error(ArgumentError) }
    end

    context 'when provided a file pathname' do
      let(:relative_path) { 'components/folder_name/with_panache.html.erb' }

      it 'returns a linkable path to the specified folder' do
        expect(path).to eql(helper.short_page_path(relative_path))
      end
    end

    context 'when provided a scrapbook and a file that belongs to it' do
      let(:scrapbook) { Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root) }
      let(:relative_path) { 'components/folder_name/with_panache.html.erb' }

      it 'returns a linkable path to the specified folder' do
        expect(path).to eql(helper.short_page_path(relative_path))
      end
    end

    context 'when the file is not in the provided scrapbook' do
      let(:pathname) { Rails.root('config/environment.rb') }
      let(:scrapbook) { Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root) }

      it { will_be_expected.to raise_error(ArgumentError) }
    end

    context 'when linking to folders in a scrapbook that is not the default one' do
      include_context 'configure scrapcook'

      let(:scrapbook_root) { PathnameHelpers.new.scrapbook_root('scrapcook') }
      let(:pathname) { PathnameHelpers.new.pages_pathname(scrapbook_root).join(relative_path) }
      let(:relative_path) { 'pastry' }

      it 'returns a linkable path prefixed with the scrapbook' do
        expect(path).to eql(helper.book_page_path(relative_path, book: 'scrapcook'))
      end
    end

    context 'when linking to files in a scrapbook that is not the default one' do
      include_context 'configure scrapcook'

      let(:scrapbook_root) { PathnameHelpers.new.scrapbook_root('scrapcook') }
      let(:pathname) { PathnameHelpers.new.pages_pathname(scrapbook_root).join(relative_path) }
      let(:relative_path) { 'pastry/croissant.html.erb' }

      it 'returns a linkable path prefixed with the scrapbook' do
        expect(path).to eql(helper.book_page_path(relative_path, book: 'scrapcook'))
      end
    end
  end

  describe '#remove_handler_exts_from' do
    subject(:no_exts) { described_class.new(helper).remove_handler_exts_from(pathname) }

    let(:pathname) { PathnameHelpers.new.pages_pathname.join(relative_file_path) }

    context 'when given a pathname to an ERB template' do
      let(:relative_file_path) { 'components/folder_name/with_panache.html.erb' }

      it 'returns a pathname with the extensions removed' do
        expect(no_exts.to_s).to eql(pathname.to_s.sub(/\..*\z/, ''))
      end
    end

    context 'when given a pathname to a custom-handled template' do
      let(:relative_file_path) { 'components/austen.html.slim' }

      it 'returns a pathname to the specified template with the extensions removed' do
        expect(no_exts.to_s).to eql(pathname.to_s.sub(/\..*\z/, ''))
      end
    end

    context 'when given a pathname to a non-HTML file' do
      let(:relative_file_path) { 'assets/fireworks.jpg' }

      it 'returns a pathname to the specified file' do
        expect(no_exts).to eql(pathname)
      end
    end
  end
end
