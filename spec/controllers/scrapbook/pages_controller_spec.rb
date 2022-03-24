# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scrapbook::PagesController, :aggregate_failures do
  routes { Scrapbook::Engine.routes }

  describe '#index' do
    before { allow(controller).to receive(:render).and_call_original }

    context 'when no book is specified' do
      it 'gets the listing of the pages directory for the default scrapbook' do
        get :index
        scrapbook = Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root)
        pathname  = scrapbook.pages_pathname

        expect(pathname).not_to be_empty
        expect(response).to have_http_status(:ok).and render_template(:index)
        expect(controller).to have_received(:render)
          .with a_hash_including(locals: {scrapbook: scrapbook, pathname: pathname})
      end

      it 'gets the listing of the specified sub directory for the default scrapbook' do
        get :index, params: {path: 'components'}
        scrapbook = Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root)
        pathname  = scrapbook.pages_pathname.join('components')

        expect(pathname).not_to be_empty
        expect(response).to have_http_status(:ok).and render_template(:index)
        expect(controller).to have_received(:render)
          .with a_hash_including(locals: {scrapbook: scrapbook, pathname: pathname})
      end

      it "returns a 404 error when the path doesn't exist" do
        get :index, params: {path: 'missing'}
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'with a specified book' do
      it 'gets the listing of the pages directory for the specified book' do
        get :index, params: {book: 'scrapbook'}
        scrapbook = Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root)
        pathname  = scrapbook.pages_pathname

        expect(pathname).not_to be_empty
        expect(response).to have_http_status(:ok).and render_template(:index)
        expect(controller).to have_received(:render)
          .with a_hash_including(locals: {scrapbook: scrapbook, pathname: pathname})
      end

      it "returns a 404 error when the book doesn't exist" do
        get :index, params: {book: 'missing'}
        expect(response).to have_http_status(:not_found)
      end

      it 'gets the listing of the specified sub directory for the specified book' do
        get :index, params: {book: 'scrapbook', path: 'components'}
        scrapbook = Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root)
        pathname  = scrapbook.pages_pathname.join('components')

        expect(pathname).not_to be_empty
        expect(response).to have_http_status(:ok).and render_template(:index)
        expect(controller).to have_received(:render)
          .with a_hash_including(locals: {scrapbook: scrapbook, pathname: pathname})
      end

      it "returns a 404 error when the path doesn't exist" do
        get :index, params: {path: 'missing'}
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
