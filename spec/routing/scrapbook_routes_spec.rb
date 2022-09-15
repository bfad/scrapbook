# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scrapbook do
  routes { Scrapbook::Engine.routes }

  describe 'the root route (/)' do
    subject { {get: '/'} }

    it { is_expected.to route_to(controller: 'scrapbook/pages', action: 'index') }
  end

  describe 'Direct routes to pages' do
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

  describe 'Raw routes to pages' do
    it 'correctly routes to the show page path' do
      expect(get: '/.raw/pages/area/subject/item.xml').to route_to(
        controller: 'scrapbook/pages',
        action: 'raw',
        id: 'area/subject/item.xml'
      )
    end
  end
end
