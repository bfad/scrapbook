# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scrapbook::HelperForView do
  describe '#short_path_to' do
    subject(:path) { described_class.new(helper).short_path_to(pathname, scrapbook) }

    let(:pathname) { PathnameHelpers.new.pages_pathname.join(relative_folder_path) }
    let(:scrapbook) { nil }
    let(:relative_folder_path) { 'components/folder_name/sub_stuff' }

    it 'returns a linkable path to the specified folder with path dividers not URL escaped' do
      expect(path).to eql(helper.short_page_path(relative_folder_path))
    end

    context 'when provided the scrapbook the folder belongs to' do
      let(:scrapbook) { Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root) }

      it 'returns a linkable path to the specified folder without escaping the path dividers' do
        expect(path).to eql(helper.short_page_path(relative_folder_path))
      end
    end

    context 'when the folder is not in the provided scrapbook' do
      let(:pathname) { Rails.root }
      let(:scrapbook) { Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root) }

      it { will_be_expected.to raise_error(ArgumentError) }
    end

    context 'when provided a file pathname' do
      let(:relative_file_path) { 'components/folder_name/with_panache.html.erb' }

      it 'returns a linkable path to the specified folder without escaping the path dividers' do
        expect(path).to eql(helper.short_page_path(relative_folder_path))
      end
    end

    context 'when provided a scrapbook and a file that belongs to it' do
      let(:scrapbook) { Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root) }
      let(:relative_file_path) { 'components/folder_name/with_panache.html.erb' }

      it 'returns a linkable path to the specified folder without escaping the path dividers' do
        expect(path).to eql(helper.short_page_path(relative_folder_path))
      end
    end

    context 'when the file is not in the provided scrapbook' do
      let(:pathname) { Rails.root('config/environment.rb') }
      let(:scrapbook) { Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root) }

      it { will_be_expected.to raise_error(ArgumentError) }
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
