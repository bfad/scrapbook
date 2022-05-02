# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scrapbook::Engine do
  describe 'configuring the engine' do
    it 'defaults to scrapbook' do
      skip 'USE_CUSTOM_PATH is set' if ENV['USE_CUSTOM_PATH'].present?

      expect(described_class.config.scrapbook.paths)
        .to eql([Rails.root.join('scrapbook')])
    end

    it 'allows the application to configure scrapbook paths' do
      skip 'USE_CUSTOM_PATH not set' if ENV['USE_CUSTOM_PATH'].blank?

      expect(described_class.config.scrapbook.paths)
        .to eql([Rails.root.join('custom/scrapbook/path')])
    end
  end

  describe 'configuring asset precompilation' do
    it 'defaults to not precompiling assets' do
      skip 'PRECOMPILE_ASSETS is set' if ENV['PRECOMPILE_ASSETS'].present?

      expect(described_class.config.scrapbook.precompile_assets).to be false
      expect(described_class.config.assets.precompile)
        .to exclude('scrapbook/tailwind_preflight_reset.css', 'scrapbook/tailwind.css')
    end

    it 'allows the application to turn on asset precompilation' do
      skip 'PRECOMPILE_ASSETS not set' if ENV['PRECOMPILE_ASSETS'].blank?

      expect(described_class.config.scrapbook.precompile_assets).to be true
      expect(described_class.config.assets.precompile)
        .to include('scrapbook/tailwind_preflight_reset.css', 'scrapbook/tailwind.css')
    end
  end
end
