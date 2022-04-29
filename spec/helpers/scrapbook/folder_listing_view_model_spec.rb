# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scrapbook::FolderListingViewModel do
  let(:scrapbook) { Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root) }

  describe '#pathname' do
    it 'uses the passed in folder' do
      pathname = PathnameHelpers.new.pages_pathname.join('components')
      listing = described_class.new(helper, scrapbook, pathname)
      expect(listing.pathname).to eql(pathname)
    end

    it 'uses the parent folder if passed a file' do
      pathname = PathnameHelpers.new.pages_pathname.join('components/austen.html.slim')
      listing = described_class.new(helper, scrapbook, pathname)
      expect(listing.pathname).to eql(pathname.parent)
    end
  end

  describe '#root?' do
    it 'returns false if viewing a folder at the root of the scrapbook' do
      pathname = PathnameHelpers.new.pages_pathname.join('components')
      listing = described_class.new(helper, scrapbook, pathname)
      expect(listing.root?).to be false
    end

    it 'returns true if viewing the scrapbook root' do
      pathname = PathnameHelpers.new.pages_pathname
      listing = described_class.new(helper, scrapbook, pathname)
      expect(listing.root?).to be true
    end

    it 'returns true if viewing a file at the root of the scrapbook' do
      pathname = PathnameHelpers.new.pages_pathname.join('welcome.html.erb')
      listing = described_class.new(helper, scrapbook, pathname)
      expect(listing.root?).to be true
    end
  end

  describe '#parent_display_name' do
    it 'returns nil if listing the root folder' do
      pathname = PathnameHelpers.new.pages_pathname
      listing = described_class.new(helper, scrapbook, pathname)
      expect(listing.parent_display_name).to be nil
    end

    it 'returns the name of the scrapbook for folders at the root level' do
      pathname = PathnameHelpers.new.pages_pathname.join('components')
      listing = described_class.new(helper, scrapbook, pathname)
      expect(listing.parent_display_name).to eql(scrapbook.name)
    end

    it 'returns the name of the parent folder for deeply nested folders' do
      pathname = PathnameHelpers.new.pages_pathname.join('components/folder_name')
      listing = described_class.new(helper, scrapbook, pathname)
      expect(listing.parent_display_name).to eql('components')
    end
  end

  describe '#header_name' do
    it 'only prefixes the scrapbook name when listing the root folder' do
      pathname = PathnameHelpers.new.pages_pathname
      listing = described_class.new(helper, scrapbook, pathname)
      expect(listing.header_name).to eql("/#{scrapbook.name}")
    end

    it 'prefixes and suffixes the folder name with a slash' do
      pathname = PathnameHelpers.new.pages_pathname.join('components')
      listing = described_class.new(helper, scrapbook, pathname)
      expect(listing.header_name).to eql('/components/')
    end
  end

  describe '#folders' do
    subject(:listing) { described_class.new(helper, scrapbook, pathname) }

    let(:pathname) { PathnameHelpers.new.pages_pathname }

    it 'returns an array of sub-folders (non-recursively) sorted by name' do
      expected = pathname.children.select(&:directory?)
        .sort { |a, b| a.to_s.downcase <=> b.to_s.downcase }

      expect(listing.folders).to eql(expected)
    end

    it 'ignores hidden directories (prefixed with a period)' do
      hidden = pathname.join('.config')
      FileUtils.mkdir(hidden)

      expect(listing.folders).not_to include(hidden)
    ensure
      FileUtils.remove_dir(hidden)
    end
  end

  describe '#files' do
    subject(:listing) { described_class.new(helper, scrapbook, pathname) }

    let(:pathname) { PathnameHelpers.new.pages_pathname.join('components') }

    it 'returns an array of files in the directory without their handler extensions and sorted by name' do
      expected = pathname.children.reject(&:directory?)
        .map { |e| Pathname.new(e.to_s.delete_suffix('.html.erb').delete_suffix('.html.slim')) }
        .sort { |a, b| a.to_s.downcase <=> b.to_s.downcase }

      expect(listing.files).to eql(expected)
    end

    it 'ignores hidden files (prefixed with a period)' do
      hidden = pathname.join('.keep')
      FileUtils.touch(hidden)

      expect(listing.files).not_to include(hidden)
    ensure
      FileUtils.remove_file(hidden)
    end
  end
end
