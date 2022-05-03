# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scrapbook do
  routes { Scrapbook::Engine.routes }

  describe 'Routes to root / Pages#index' do
    context 'with the short route to route' do
      subject { {get: '/'} }

      it { is_expected.to route_to(controller: 'scrapbook/pages', action: 'index') }
    end

    context 'with the pages prefix' do
      subject { {get: '/pages'} }

      it { is_expected.to route_to(controller: 'scrapbook/pages', action: 'index') }
    end

    context 'with the book prefix' do
      subject { {get: '/scrapbook'} }

      it { is_expected.to route_to(controller: 'scrapbook/pages', action: 'index', book: 'scrapbook') }
    end

    context 'with both the book and pages prefix' do
      subject { {get: '/scrapbook/pages'} }

      it { is_expected.to route_to(controller: 'scrapbook/pages', action: 'index', book: 'scrapbook') }
    end
  end

  describe 'Direct routes to pages' do
    context 'without the pages prefix' do
      it 'correctly routes viewing a long path' do
        expect(get: '/area/subject/item').to route_to(
          controller: 'scrapbook/pages',
          action: 'show',
          id: 'area/subject/item'
        )
      end

      it 'correctly routes viewing a long file' do
        expect(get: '/area/subject/item.xml').to route_to(
          controller: 'scrapbook/pages',
          action: 'show',
          id: 'area/subject/item.xml'
        )
      end
    end

    context 'with the pages prefix' do
      it 'correctly routes indexing the pages' do
        expect(get: '/pages').to route_to('scrapbook/pages#index')
      end

      it 'correctly routes viewing a long path' do
        expect(get: '/pages/area/subject/item').to route_to(
          controller: 'scrapbook/pages',
          action: 'show',
          id: 'area/subject/item'
        )
      end

      it 'correctly routes viewing a long file' do
        expect(get: '/pages/area/subject/item.xml').to route_to(
          controller: 'scrapbook/pages',
          action: 'show',
          id: 'area/subject/item.xml'
        )
      end

      it 'correctly routes viewing a page named pages' do
        expect(get: '/pages/pages').to route_to(
          controller: 'scrapbook/pages',
          action: 'show',
          id: 'pages'
        )
      end

      it 'correctly routes editing a long path' do
        expect(get: '/pages/area/subject/item/edit').to route_to(
          controller: 'scrapbook/pages',
          action: 'edit',
          id: 'area/subject/item'
        )
      end

      it 'correctly routes updating a long path' do
        expect(put: '/pages/area/subject/item').to route_to(
          controller: 'scrapbook/pages',
          action: 'update',
          id: 'area/subject/item'
        )
      end

      it 'correctly routes the new page path' do
        expect(get: '/pages/new').to route_to('scrapbook/pages#new')
      end

      it 'correctly routes creating a new page' do
        expect(post: '/pages').to route_to('scrapbook/pages#create')
      end
    end
  end

  # Since the default book is "scrapbook", that's the prefix we will use. This
  # means that mounted under "scrapbook" in an application, the URLs would be
  # in the form "/scrapbook/scrapbook/..."
  describe 'Book-prefixed routes to pages' do
    context 'without the pages prefix' do
      it 'correctly routes viewing a long path' do
        expect(get: '/scrapbook/area/subject/item').to route_to(
          controller: 'scrapbook/pages',
          action: 'show',
          book: 'scrapbook',
          id: 'area/subject/item'
        )
      end
    end

    context 'with the pages prefix' do
      it 'correctly routes indexing the pages' do
        expect(get: '/scrapbook/pages').to route_to(
          controller: 'scrapbook/pages',
          action: 'index',
          book: 'scrapbook'
        )
      end

      it 'correctly routes viewing a long path' do
        expect(get: '/scrapbook/pages/area/subject/item').to route_to(
          controller: 'scrapbook/pages',
          action: 'show',
          book: 'scrapbook',
          id: 'area/subject/item'
        )
      end

      it 'correctly routes viewing a long file' do
        expect(get: '/scrapbook/pages/area/subject/item.xml').to route_to(
          controller: 'scrapbook/pages',
          action: 'show',
          book: 'scrapbook',
          id: 'area/subject/item.xml'
        )
      end

      it 'correctly routes viewing a page named pages' do
        expect(get: '/scrapbook/pages/pages').to route_to(
          controller: 'scrapbook/pages',
          action: 'show',
          book: 'scrapbook',
          id: 'pages'
        )
      end

      it 'correctly routes editing a long path' do
        expect(get: '/scrapbook/pages/area/subject/item/edit').to route_to(
          controller: 'scrapbook/pages',
          action: 'edit',
          book: 'scrapbook',
          id: 'area/subject/item'
        )
      end

      it 'correctly routes updating a long path' do
        expect(put: '/scrapbook/pages/area/subject/item').to route_to(
          controller: 'scrapbook/pages',
          action: 'update',
          book: 'scrapbook',
          id: 'area/subject/item'
        )
      end

      it 'correctly routes the new page path' do
        expect(get: '/scrapbook/pages/new').to route_to(
          controller: 'scrapbook/pages',
          action: 'new',
          book: 'scrapbook'
        )
      end

      it 'correctly routes creating a new page' do
        expect(post: '/scrapbook/pages').to route_to(
          controller: 'scrapbook/pages',
          action: 'create',
          book: 'scrapbook'
        )
      end
    end
  end

  describe 'Raw routes to pages' do
    it 'correctly routes to the show page path' do
      expect(get: '/.raw/scrapbook/pages/area/subject/item.xml').to route_to(
        controller: 'scrapbook/pages',
        action: 'raw',
        book: 'scrapbook',
        id: 'area/subject/item.xml',
        raw: true
      )
    end
  end
end
