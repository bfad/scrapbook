# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'scrapbook/pages/index' do
  let(:parsed) { Nokogiri::HTML5(rendered) }

  describe 'the heading' do
    it 'renders just a slash when viewing the root folder' do
      scrapbook = Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root)
      render template: self.class.top_level_description,
        locals: {scrapbook: scrapbook, pathname: scrapbook.pages_pathname}

      expect(parsed.at_css('header').text).to eql('/')
    end

    it 'renders the folder name' do
      scrapbook = Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root)
      path = 'components/folder_name'
      render template: self.class.top_level_description,
        locals: {scrapbook: scrapbook, pathname: scrapbook.pages_pathname.join(path)}

      expect(parsed.at('header').text).to eql("/#{path}")
    end
  end

  it 'renders the contents of a folder' do # rubocop:disable RSpec/ExampleLength
    scrapbook = Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root)
    contents = scrapbook.pages_pathname.children
    render template: self.class.top_level_description,
      locals: {scrapbook: scrapbook, pathname: scrapbook.pages_pathname}

    expect(contents).not_to be_empty
    contents.each do |child|
      value = child.directory? ? "#{child.basename}/" : child.basename.sub(/\..*\z/, '')
      expect(parsed.at(%[li > a:contains("#{value}")])).to be_present
    end
  end
end
