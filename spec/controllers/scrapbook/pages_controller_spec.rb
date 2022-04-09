# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scrapbook::PagesController, :aggregate_failures do
  routes { Scrapbook::Engine.routes }

  describe '#index' do
    let(:scrapbook) { Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root) }

    before { allow(controller).to receive(:render).and_call_original }

    context 'when no book is specified' do
      it 'gets the listing of the pages directory for the default scrapbook' do
        get :index
        pathname = scrapbook.pages_pathname

        expect(pathname).not_to be_empty
        expect(response).to have_http_status(:ok).and render_template('pages')
        expect(controller).to have_received(:render)
          .with a_hash_including(locals: {scrapbook: scrapbook, pathname: pathname})
      end

      it 'gets the listing of the specified sub directory for the default scrapbook' do
        get :index, params: {path: 'components'}
        pathname = scrapbook.pages_pathname.join('components')

        expect(pathname).not_to be_empty
        expect(response).to have_http_status(:ok).and render_template(:index)
        expect(controller).to have_received(:render)
          .with a_hash_including(locals: {scrapbook: scrapbook, pathname: pathname})
      end

      it 'renders the root template for the root directory if it exists' do
        FileUtils.touch(scrapbook.pages_pathname.sub_ext('.html.erb'))

        get :index
        expect(response).to have_http_status(:ok).and render_template('pages')
        expect(controller).to have_received(:render)
          .with a_hash_including(locals: {scrapbook: scrapbook, pathname: scrapbook.pages_pathname})
      ensure
        FileUtils.remove_file(scrapbook.pages_pathname.sub_ext('.html.erb'))
      end

      it "returns a 404 error when the path doesn't exist" do
        get :index, params: {path: 'missing'}
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'with a specified book' do
      it 'gets the listing of the pages directory for the specified book' do
        get :index, params: {book: 'scrapbook'}
        pathname = scrapbook.pages_pathname

        expect(pathname).not_to be_empty
        expect(response).to have_http_status(:ok).and render_template('pages')
        expect(controller).to have_received(:render)
          .with a_hash_including(locals: {scrapbook: scrapbook, pathname: pathname})
      end

      it "returns a 404 error when the book doesn't exist" do
        get :index, params: {book: 'missing'}
        expect(response).to have_http_status(:not_found)
      end

      it 'gets the listing of the specified sub directory for the specified book' do
        get :index, params: {book: 'scrapbook', path: 'components'}
        pathname = scrapbook.pages_pathname.join('components')

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

  describe '#show' do
    context 'when short path or pages path is used' do
      it 'renders the specified template for the default scrapbook' do
        get :show, params: {id: 'welcome'}
        expect(response).to render_template('welcome')
        expect(response).to render_template('layouts/scrapbook/application')
      end

      it 'renders the matching template for a request with an "html" extension in the default scrapbook' do
        get :show, params: {id: 'welcome.html'}
        expect(response).to render_template('welcome')
        expect(response).to render_template('layouts/scrapbook/application')
      end

      it 'renders a directory listing for the specified folder in the default scrapbook' do
        get :show, params: {id: 'components/folder_name/sub_stuff'}
        expect(response).to render_template('scrapbook/pages/index')
        expect(response).to render_template('layouts/scrapbook/application')
      end

      it 'renders the show template in the engine' do
        get :show, params: {id: 'assets/fireworks.jpg'}
        expect(response).to have_http_status(:ok)
        expect(response).to render_template('scrapbook/pages/show')
        expect(response).to render_template('layouts/scrapbook/application')
      end

      it 'prefers to render the template over a directory or file' do
        get :show, params: {id: 'components/folder_name'}
        expect(response).to render_template('components/folder_name')
        expect(response).to render_template('layouts/scrapbook/application')
      end

      it "returns a 404 error when the path doesn't exist" do
        get :show, params: {id: 'missing'}
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'with book in the path' do
      it 'renders the specified template for the specified scrapbook' do
        get :show, params: {book: 'scrapbook', id: 'welcome'}
        expect(response).to render_template('welcome')
        expect(response).to render_template('layouts/scrapbook/application')
      end

      it 'renders the matching template for a request with an "html" extension in the specified scrapbook' do
        get :show, params: {book: 'scrapbook', id: 'welcome.html'}
        expect(response).to render_template('welcome')
        expect(response).to render_template('layouts/scrapbook/application')
      end

      it 'renders a directory listing for the specified folder in the specified scrapbook' do
        get :show, params: {book: 'scrapbook', id: 'components/folder_name/sub_stuff'}
        expect(response).to render_template('scrapbook/pages/index')
        expect(response).to render_template('layouts/scrapbook/application')
      end

      it 'renders the show template in the engine' do
        get :show, params: {book: 'scrapbook', id: 'assets/fireworks.jpg'}
        expect(response).to have_http_status(:ok)
        expect(response).to render_template('scrapbook/pages/show')
        expect(response).to render_template('layouts/scrapbook/application')
      end

      it 'prefers to render the template over a directory or file' do
        get :show, params: {book: 'scrapbook', id: 'components/folder_name'}
        expect(response).to render_template('components/folder_name')
        expect(response).to render_template('layouts/scrapbook/application')
      end

      it "returns a 404 error when the path doesn't exist" do
        get :show, params: {book: 'scrapbook', id: 'missing'}
        expect(response).to have_http_status(:not_found)
      end

      it "returns a 404 error when the scrapbook doesn't exist" do
        get :show, params: {book: 'missing', id: 'welcome'}
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'with the raw path is used' do
      it 'renders the specified template for the specified scrapbook' do
        get :show, params: {raw: true, book: 'scrapbook', id: 'welcome'}
        expect(response).to render_template('welcome')
        expect(response).not_to render_template('layouts/scrapbook/application')
      end

      it 'renders the matching template for a request with an "html" extension in the specified scrapbook' do
        get :show, params: {raw: true, book: 'scrapbook', id: 'welcome.html'}
        expect(response).to render_template('welcome')
        expect(response).not_to render_template('layouts/scrapbook/application')
      end

      it 'renders a directory listing for the specified folder in the specified scrapbook' do
        get :show, params: {raw: true, book: 'scrapbook', id: 'components/folder_name/sub_stuff'}
        expect(response).to render_template('scrapbook/pages/index')
        expect(response).not_to render_template('layouts/scrapbook/application')
      end

      it 'renders the show template in the engine' do
        get :show, params: {raw: true, book: 'scrapbook', id: 'assets/fireworks.jpg'}
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(nil)
      end

      it 'prefers to render the template over a directory or file' do
        get :show, params: {raw: true, book: 'scrapbook', id: 'components/folder_name'}
        expect(response).to render_template('components/folder_name')
        expect(response).not_to render_template('layouts/scrapbook/application')
      end

      it "returns a 404 error when the path doesn't exist" do
        get :show, params: {raw: true, book: 'scrapbook', id: 'missing'}
        expect(response).to have_http_status(:not_found)
      end

      it "returns a 404 error when the scrapbook doesn't exist" do
        get :show, params: {raw: true, book: 'missing', id: 'welcome'}
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when viewing the ID "pages"' do
      render_views # Can't be called or configured in an example

      let(:scrapbook) { Scrapbook::Scrapbook.new(PathnameHelpers.new.scrapbook_root) }

      it 'renders it with a short or pages path' do
        scrapbook.pages_pathname.join('pages.html.erb').write('edge-case for /pages')
        get :show, params: {id: 'pages'}

        expect(response).to render_template('pages')
        expect(response).to render_template('layouts/scrapbook/application')
        expect(response.body).to match(%r{edge-case for /pages})
      ensure
        FileUtils.remove_file(scrapbook.pages_pathname.join('pages.html.erb'))
      end

      it 'renders it with a book path' do
        scrapbook.pages_pathname.join('pages.html.erb').write('edge-case for /pages')
        get :show, params: {book: 'scrapbook', id: 'pages'}

        expect(response).to render_template('pages')
        expect(response).to render_template('layouts/scrapbook/application')
        expect(response.body).to match(%r{edge-case for /pages})
      ensure
        FileUtils.remove_file(scrapbook.pages_pathname.join('pages.html.erb'))
      end

      it 'renders it with a raw path' do
        scrapbook.pages_pathname.join('pages.html.erb').write('edge-case for /pages')
        get :show, params: {raw: true, book: 'scrapbook', id: 'pages'}

        expect(response).to render_template('pages')
        expect(response).not_to render_template('layouts/scrapbook/application')
        expect(response.body).to match(%r{edge-case for /pages})
      ensure
        FileUtils.remove_file(scrapbook.pages_pathname.join('pages.html.erb'))
      end
    end

    context %(when viewing the ID "pages" which doesnt exist) do
      it 'renders not found for short or pages path' do
        get :show, params: {id: 'pages'}
        expect(response).to have_http_status(:not_found)
      end

      it 'renders not found for a book path' do
        get :show, params: {book: 'scrapbook', id: 'pages'}
        expect(response).to have_http_status(:not_found)
      end

      it 'renders not found for a raw path' do
        get :show, params: {raw: true, book: 'scrapbook', id: 'pages'}
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
