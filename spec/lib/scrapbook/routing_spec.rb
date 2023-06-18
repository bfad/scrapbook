# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scrapbook::Routing do
  # rubocop:disable RSpec/SubjectStub
  describe '#scrapbook' do
    subject(:object) { double('router').extend(described_class) } # rubocop:disable RSpec/VerifiedDoubles

    let(:books) { {} }

    before do
      allow(Scrapbook::Engine.config.scrapbook).to receive(:paths)
        .and_return(books)
      allow(object).to receive(:mount)
    end

    it 'creates a scrapbook entry in the configuration with the default file location' do
      object.scrapbook('book')

      expect(books).to include('book' => Rails.root.join('book'))
    end

    it 'mounts Scrapbook with the default values' do
      object.scrapbook('book')

      expect(object).to have_received(:mount).with(hash_including(
        Scrapbook::Engine => '/book',
        defaults: {'.book': 'book'},
        as: 'book_scrapbook'
      ))
    end

    context 'when passed a URL path' do
      it 'mounts Scrapbook at the specified path' do
        path = '/my/path'
        object.scrapbook('book', at: path)

        expect(object).to have_received(:mount).with(hash_including(
          Scrapbook::Engine => path,
          defaults: {'.book': 'book'},
          as: 'book_scrapbook'
        ))
      end
    end

    context 'when passed a folder root' do
      it 'configures the scrapbook entry with the specified root folder' do
        root = '/the/path/to/book/root'
        object.scrapbook('book', folder_root: root)

        expect(books).to include('book' => Pathname.new(root))
      end

      it 'configures the scrapbook entry with the specified root folder relative to Rails.root' do
        path = 'relative/path/to/root'
        object.scrapbook('book', folder_root: path)

        expect(books).to include('book' => Rails.root.join(path))
      end
    end
  end
  # rubocop:enable RSpec/SubjectStub
end
