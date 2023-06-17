# frozen_string_literal: true

require 'rails_helper'

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

  describe '#nav_link_for' do
    subject(:nav_link) { Nokogiri::HTML5.fragment(described_class.new(helper).nav_link_for(**args)).children.first }

    let(:scrapbook) { Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root) }
    let(:pathname) { PathnameHelpers.new.pages_pathname.join('components/folder_name/sub_stuff') }
    let(:required_args) { {scrapbook: scrapbook, pathname: pathname} }
    let(:args) { required_args }

    it 'returns a link with the default markup' do
      expect(nav_link.text).to eql(pathname.basename.to_s)
      expect(nav_link.get_attribute(:href)).to eql(described_class.new(helper).short_path_to(pathname, scrapbook))
      expect(nav_link.get_attribute(:'data-turbo-frame')).to eql('page_content')
      expect(nav_link.get_attribute(:class)).to eql('block w-100')
    end

    context 'when given the path to the pages folder of the scrapbook' do
      let(:pathname) { PathnameHelpers.new.pages_pathname }

      it 'uses the scrapbook name for the link' do
        expect(nav_link.text).to eql(scrapbook.name)
      end
    end

    context 'when `is_current` is true' do
      let(:args) { required_args.merge(is_current: true) }

      it 'adds an "aria-current" annotation' do
        expect(nav_link.get_attribute(:'aria-current')).to eql('page')
      end
    end

    context 'when given a depth value' do
      let(:args) { required_args.merge(depth: 3) }

      it 'adds padding for the specified depth' do
        expect(nav_link.get_attribute(:style)).to eql('padding-left: 3rem;')
      end
    end

    context 'when additional classes are specified' do
      let(:args) { required_args.merge(class: 'grow foo-bar') }

      it 'appends the class names' do
        expect(nav_link.get_attribute(:class)).to eql('block w-100 grow foo-bar')
      end
    end

    context 'when additional data attributes are passed' do
      let(:args) { required_args.merge(data: {hint: 33, fun: 'yes'}) }

      it 'preserves the data-turbo-frame attribute' do
        expect(nav_link.get_attribute(:'data-turbo-frame')).to eql('page_content')
      end

      it 'adds the additional data attributes' do
        expect(nav_link.get_attribute(:'data-hint')).to eql('33')
        expect(nav_link.get_attribute(:'data-fun')).to eql('yes')
      end
    end

    context 'when additional aria attributes are passed with `is_current` set to true' do
      let(:args) { required_args.merge(is_current: true, aria: {label: 'back'}) }

      it 'preserves the current attribute' do
        expect(nav_link.get_attribute(:'aria-current')).to eql('page')
      end

      it 'adds the additional data attributes' do
        expect(nav_link.get_attribute(:'aria-label')).to eql('back')
      end
    end

    context 'when passed random attributes' do
      let(:args) { required_args.merge(foo: 'bar', baz: 'quuz') }

      it 'adds them to the html markup' do
        expect(nav_link.get_attribute(:foo)).to eql('bar')
        expect(nav_link.get_attribute(:baz)).to eql('quuz')
      end
    end
  end
end
