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
end
