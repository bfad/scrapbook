# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'layouts/scrapbook/folder_listing' do
  let(:parsed) { Nokogiri::HTML5.fragment(rendered) }

  describe 'the heading' do
    it 'renders just a slash when viewing the root folder' do
      scrapbook = Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root)
      render partial: self.class.top_level_description,
        locals: {scrapbook: scrapbook, pathname: scrapbook.pages_pathname}

      expect(parsed.at_css('header').text).to eql('/')
    end

    it 'renders the folder name' do
      scrapbook = Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root)
      pathname  = scrapbook.pages_pathname.join('components/folder_name')
      render partial: self.class.top_level_description,
        locals: {scrapbook: scrapbook, pathname: pathname}

      expect(parsed.at('header').text).to eql("/#{pathname.basename}/")
    end
  end

  describe 'back breadcrumb' do
    it 'renders nothing when viewing the root folder' do
      scrapbook = Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root)
      pathname  = scrapbook.pages_pathname
      render partial: self.class.top_level_description,
        locals: {scrapbook: scrapbook, pathname: pathname}

      expect(parsed.at('a.back-to-parent')).to be nil
    end

    it 'renders a slash when viewing a sub-folder of the root' do
      scrapbook = Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root)
      pathname  = scrapbook.pages_pathname.join('components')
      render partial: self.class.top_level_description,
        locals: {scrapbook: scrapbook, pathname: pathname}

      expect(parsed.at('a.back-to-parent').text).to eql('‹ /')
    end

    it 'renders the name of the deeply nested folder' do
      scrapbook = Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root)
      pathname  = scrapbook.pages_pathname.join('components/folder_name')
      render partial: self.class.top_level_description,
        locals: {scrapbook: scrapbook, pathname: pathname}

      expect(parsed.at('a.back-to-parent').text).to eql("‹ #{pathname.dirname.basename}")
    end

    it 'renders nothing when the parent of the currently selected file is the root folder' do
      scrapbook = Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root)
      pathname  = scrapbook.pages_pathname.join('welcome')
      render partial: self.class.top_level_description,
        locals: {scrapbook: scrapbook, pathname: pathname}

      expect(parsed.at('a.back-to-parent')).to be nil
    end

    it 'renders the name of the parent of the currently selected file' do
      scrapbook = Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root)
      pathname  = scrapbook.pages_pathname.join('components/austen')
      render partial: self.class.top_level_description,
        locals: {scrapbook: scrapbook, pathname: pathname}

      expect(parsed.at('a.back-to-parent').text).to eql('‹ /')
    end

    it 'renders the name of the deeply nested parent of the currently selected file' do
      scrapbook = Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root)
      pathname  = scrapbook.pages_pathname.join('components/folder_name/with_panache')
      render partial: self.class.top_level_description,
        locals: {scrapbook: scrapbook, pathname: pathname}

      expect(parsed.at('a.back-to-parent').text).to eql("‹ #{pathname.dirname.dirname.basename}")
    end
  end

  it 'renders the contents of a folder' do # rubocop:disable RSpec/ExampleLength
    scrapbook = Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root)
    contents = scrapbook.pages_pathname.children
    render partial: self.class.top_level_description,
      locals: {scrapbook: scrapbook, pathname: scrapbook.pages_pathname}

    expect(contents).not_to be_empty
    contents.each do |child|
      value = child.directory? ? "#{child.basename}/" : child.basename.sub(/\..*\z/, '')
      expect(parsed.at(%[li > a:contains("#{value}")])).to be_present
    end
  end

  it "doesn't render hidden files (files starting with a period)" do
    scrapbook = Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root)
    pathname = scrapbook.pages_pathname.join('components/folder_name/sub_stuff')
    render partial: self.class.top_level_description,
      locals: {scrapbook: scrapbook, pathname: pathname}

    expect(pathname.join('.keep')).to be_exist
    expect(parsed.at('li > a')).not_to be_present
  end

  it "doesn't render template files whose names match their parent folder" do
    scrapbook = Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root)
    pathname = scrapbook.pages_pathname.join('components/folder_name.html.erb')
    render partial: self.class.top_level_description,
      locals: {scrapbook: scrapbook, pathname: pathname}

    expect(parsed.css(%[li > a:contains("folder_name")]).size).to be 1
  end
end
