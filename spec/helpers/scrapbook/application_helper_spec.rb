# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scrapbook::ApplicationHelper do
  describe '#short_link_to_folder' do
    subject(:link) { helper.short_link_to_folder(pathname, scrapbook) }

    let(:pathname) { PathnameHelpers.new.pages_pathname.join(relative_folder_path) }
    let(:scrapbook) { nil }
    let(:relative_folder_path) { 'components/folder_name/sub_stuff' }

    it 'returns a formatted link to the specified folder' do
      anchor = Nokogiri::HTML5.fragment(link).children.first
      expect(anchor.text).to eql("#{pathname.basename}/")
      expect(anchor.attribute('href').value).to eql(helper.short_page_path(relative_folder_path))
    end

    context 'when provided the scrapbook the page belongs to' do
      let(:scrapbook) { Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root) }

      it 'returns a link to the specified folder' do
        anchor = Nokogiri::HTML5.fragment(link).children.first
        expect(anchor.text).to eql("#{pathname.basename}/")
        expect(anchor.attribute('href').value).to eql(helper.short_page_path(relative_folder_path))
      end
    end

    context 'when the page is not in the provided scrapbook' do
      let(:pathname) { Rails.root }
      let(:scrapbook) { Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root) }

      it { will_be_expected.to raise_error(ArgumentError) }
    end
  end

  describe '#short_link_to_file' do
    subject(:link) { helper.short_link_to_file(pathname, scrapbook) }

    let(:pathname) { PathnameHelpers.new.pages_pathname.join(relative_file_path) }
    let(:scrapbook) { nil }
    let(:relative_file_path) { 'components/folder_name/with_panache.html.erb' }
    let(:noext_relative_path) { relative_file_path.sub(/\..*\z/, '') }

    it 'returns a formatted link to the specified folder' do
      anchor = Nokogiri::HTML5.fragment(link).children.first
      expect(anchor.text).to eql(File.basename(noext_relative_path))
      expect(anchor.attribute('href').value).to eql(helper.short_page_path(noext_relative_path))
    end

    context 'when provided the scrapbook the page belongs to' do
      let(:scrapbook) { Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root) }

      it 'returns a link to the specified folder' do
        anchor = Nokogiri::HTML5.fragment(link).children.first
        expect(anchor.text).to eql(File.basename(noext_relative_path))
        expect(anchor.attribute('href').value).to eql(helper.short_page_path(noext_relative_path))
      end
    end

    context 'when the page is not in the provided scrapbook' do
      let(:pathname) { Rails.root.join('config/application.rb') }
      let(:scrapbook) { Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root) }

      it { will_be_expected.to raise_error(ArgumentError) }
    end
  end
end
