# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scrapbook::PagesController, :aggregate_failures do
  routes { Scrapbook::Engine.routes }

  describe '#show' do
    let(:scrapbook) { Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root) }

    it 'renders the show template for the root path (no "id" parameter)' do
      get :show, params: {'.book': 'scrapbook'}

      expect(response).to have_http_status(:ok).and render_template(:show)
      expect(template_locals).to include(
        scrapbook: scrapbook,
        pathname: scrapbook.pages_pathname
      )
    end

    it 'renders the show template for a folder with a template file' do
      get :show, params: {'.book': 'scrapbook', id: 'components/folder_name'}

      expect(response).to have_http_status(:ok).
        and render_template('layouts/scrapbook/application').
        and render_template(:show)
      expect(template_locals).to include(
        scrapbook: scrapbook,
        pathname: scrapbook.pages_pathname.join('components/folder_name')
      )
    end

    it 'renders the show template for a folder without a template file' do
      get :show, params: {'.book': 'scrapbook', id: 'components/folder_name/sub_stuff'}

      expect(response).to have_http_status(:ok).
        and render_template('layouts/scrapbook/application').
        and render_template(:show)
      expect(template_locals).to include(
        scrapbook: scrapbook,
        pathname: scrapbook.pages_pathname.join('components/folder_name/sub_stuff')
      )
    end

    it 'renders the show template for the specified template' do
      get :show, params: {'.book': 'scrapbook', id: 'welcome'}

      expect(response).to have_http_status(:ok).
        and render_template('layouts/scrapbook/application').
        and render_template(:show)
      expect(template_locals).to include(
        scrapbook: scrapbook,
        pathname: scrapbook.pages_pathname.join('welcome')
      )
    end

    it 'renders the show template when a template exists that matches a request with an "html" extension' do
      get :show, params: {'.book': 'scrapbook', id: 'welcome.html'}

      expect(response).to have_http_status(:ok).
        and render_template('layouts/scrapbook/application').
        and render_template(:show)
      expect(template_locals).to include(
        scrapbook: scrapbook,
        pathname: scrapbook.pages_pathname.join('welcome.html')
      )
    end

    it 'renders the show template when a non-template file is requested' do
      get :show, params: {'.book': 'scrapbook', id: 'assets/fireworks.jpg'}

      expect(response).to have_http_status(:ok).
        and render_template('layouts/scrapbook/application').
        and render_template(:show)
      expect(template_locals).to include(
        scrapbook: scrapbook,
        pathname: scrapbook.pages_pathname.join('assets/fireworks.jpg')
      )
    end

    it "renders the show template when the path doesn't exist" do
      get :show, params: {'.book': 'scrapbook', id: 'missing'}

      expect(response).to have_http_status(:ok).
        and render_template('layouts/scrapbook/application').
        and render_template(:show)
      expect(template_locals).to include(
        scrapbook: scrapbook,
        pathname: scrapbook.pages_pathname.join('missing')
      )
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

    context "with view rendering" do
      render_views

      it 'renders the message about creating templates for selected folder that does not have one' do
        get :raw, params: {'.book': 'scrapbook', id: 'components'}

        expect(response).to render_template('pages')
        expect(response).to render_template('layouts/scrapbook/host_application')
        expect(response).not_to include('You can add a template named "pages" to the Scrapbook root directory')
      end

      it 'renders the message about the root template for scrapbooks missing that file' do
        get :raw, params: {'.book': 'scrapbook'}

        expect(response).to render_template('pages')
        expect(response).to render_template('layouts/scrapbook/host_application')
        expect(response.body).to include('You can add a template named "pages" to the Scrapbook root directory')
      end

      it "returns a 404 error when the path doesn't exist" do
        get :raw, params: {'.book': 'scrapbook', id: 'missing'}
        expect(response).to have_http_status(:not_found)
      end
    end

    it "returns a 404 error when the scrapbook doesn't exist" do
      get :raw, params: {'.book': 'missing', id: 'welcome'}
      expect(response).to have_http_status(:not_found)
    end
  end
end
