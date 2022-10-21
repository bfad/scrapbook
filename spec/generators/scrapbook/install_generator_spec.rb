# frozen_string_literal: true

require 'rails_helper'
require 'generators/scrapbook/install_generator'

RSpec.describe Scrapbook::InstallGenerator do
  # Unit tests in the individual generators this calls

  # Testing private method so that the other generators aren't called. The way they would be
  # called would modify "test/boxcar" instead of the randomly created folder inside
  # "test/boxcar/tmp/generators_test/".
  describe '#sprockets_support' do
    context 'when a sprockets manifest file exists' do
      around do |example|
        manifest_pathname = relative_pathname('app/assets/config/manifest.js')
        manifest_pathname.dirname.mkpath
        manifest_pathname.write('')
        example.run
        manifest_pathname.dirname.rmtree
      end

      it "adds the configuration for scrapbook's CSS file" do
        capture(:stdout) { generator.send(:sprockets_support) }
        expect(relative_pathname('app/assets/config/manifest.js').read)
          .to match(%r`^//= link scrapbook/application.css$`)
      end

      it "adds the configuration for scrapbook's JS file" do
        capture(:stdout) { generator.send(:sprockets_support) }
        expect(relative_pathname('app/assets/config/manifest.js').read)
          .to match(%r`^//= link scrapbook/application.js$`)
      end
    end

    context 'without a sprockets manifest file' do
      it 'skips sprockets support' do
        capture(:stdout) { generator.send(:sprockets_support) }
        expect(relative_pathname('app/assets/config/manifest.js')).not_to exist
      end
    end
  end
end
