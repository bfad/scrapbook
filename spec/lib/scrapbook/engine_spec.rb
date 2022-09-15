# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scrapbook::Engine do
  # describe 'configuring the engine' do
  #   it 'defaults to an empty hash scrapbook' do
  #     expect(described_class.config.scrapbook.paths).to eql({})
  #   end
  # end

  describe 'configuring asset precompilation' do
    it 'defaults to not precompiling assets' do
      expect(described_class.config.scrapbook.precompile_assets).to be false
      expect(described_class.config.assets.precompile)
        .to exclude('scrapbook/application.css')
    end
  end
end
