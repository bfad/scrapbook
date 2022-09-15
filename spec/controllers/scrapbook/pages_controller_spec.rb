# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scrapbook::PagesController, :aggregate_failures do
  routes { Scrapbook::Engine.routes }

  describe '#index' do
    let(:scrapbook) { Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root) }

    it 'gets the listing of the pages directory for the specified book' do
      get :index, params: {'.book': 'scrapbook'}
      pathname = scrapbook.pages_pathname

      expect(pathname).not_to be_empty
      expect(response).to have_http_status(:ok).and render_template('pages')
      expect(template_locals).to include(scrapbook: scrapbook, pathname: pathname)
    end

    it 'gets the listing of the specified sub directory for the specified book' do
      get :index, params: {'.book': 'scrapbook', path: 'components'}
      pathname = scrapbook.pages_pathname.join('components')

      expect(pathname).not_to be_empty
      expect(response).to have_http_status(:ok).and render_template(:index)
      expect(template_locals).to include(scrapbook: scrapbook, pathname: pathname)
    end

    it "returns a 404 error when the book doesn't exist" do
      get :index, params: {'.book': 'missing'}
      expect(response).to have_http_status(:not_found)
    end

    it "returns a 404 error when the path doesn't exist" do
      get :index, params: {'.book': 'scrapbook', path: 'missing'}
      expect(response).to have_http_status(:not_found)
    end

    context 'when no book is specified' do
      it "returns a 404 error when the path doesn't exist" do
        get :index, params: {path: 'my/cool/path'}
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe '#show' do
    it 'renders the show template when the specified template exists in the specified scrapbook' do
      get :show, params: {'.book': 'scrapbook', id: 'welcome'}
      expect(response).to render_template('show')
      expect(response).to render_template('layouts/scrapbook/application')
    end

    it 'renders the show template when a template exists in the specified scrapbook that matches a request with an "html" extension' do # rubocop:disable Layout/LineLength
      get :show, params: {'.book': 'scrapbook', id: 'welcome.html'}
      expect(response).to render_template('show')
      expect(response).to render_template('layouts/scrapbook/application')
    end

    it 'renders a directory listing for the specified folder in the specified scrapbook' do
      get :show, params: {'.book': 'scrapbook', id: 'components/folder_name/sub_stuff'}
      expect(response).to render_template('scrapbook/pages/index')
      expect(response).to render_template('layouts/scrapbook/application')
    end

    it 'renders the show template when a non-template file is requested' do
      get :show, params: {'.book': 'scrapbook', id: 'assets/fireworks.jpg'}
      expect(response).to have_http_status(:ok)
      expect(response).to render_template('show')
      expect(response).to render_template('layouts/scrapbook/application')
    end

    it 'prefers to render the show template over a directory or file' do
      get :show, params: {'.book': 'scrapbook', id: 'components/folder_name'}
      expect(response).to render_template('show')
      expect(response).to render_template('layouts/scrapbook/application')
    end

    it "renders the show template when the path doesn't exist" do
      get :show, params: {'.book': 'scrapbook', id: 'missing'}
      expect(response).to have_http_status(:ok)
      expect(response).to render_template('show')
      expect(response).to render_template('layouts/scrapbook/application')
    end

    it "returns a 404 error when the scrapbook doesn't exist" do
      get :show, params: {'.book': 'missing', id: 'welcome'}
      expect(response).to have_http_status(:not_found)
    end

    context 'when no book is specified' do
      it "returns a 404 error when the path doesn't exist" do
        get :show, params: {id: 'my/cool/path'}
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe '#raw' do
    it 'renders the specified template for the specified scrapbook' do
      get :raw, params: {'.book': 'scrapbook', id: 'welcome'}
      expect(response).to render_template('welcome')
      expect(response).to render_template('layouts/scrapbook/host_application')
    end

    it 'renders the matching template for a request with an "html" extension in the specified scrapbook' do
      get :raw, params: {'.book': 'scrapbook', id: 'welcome.html'}
      expect(response).to render_template('welcome')
      expect(response).to render_template('layouts/scrapbook/host_application')
    end

    it 'renders the file directly if it is not a template' do
      get :raw, params: {'.book': 'scrapbook', id: 'assets/fireworks.jpg'}
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(nil)
    end

    it 'prefers to render the template over a directory or file' do
      get :raw, params: {'.book': 'scrapbook', id: 'components/folder_name'}
      expect(response).to render_template('components/folder_name')
      expect(response).to render_template('layouts/scrapbook/host_application')
    end

    it "returns a 404 error when the path doesn't exist" do
      get :raw, params: {'.book': 'scrapbook', id: 'missing'}
      expect(response).to have_http_status(:not_found)
    end

    it "returns a 404 error when the scrapbook doesn't exist" do
      get :raw, params: {'.book': 'missing', id: 'welcome'}
      expect(response).to have_http_status(:not_found)
    end
  end
end
