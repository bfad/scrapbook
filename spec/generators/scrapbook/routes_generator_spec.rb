# frozen_string_literal: true

require 'rails_helper'
require 'generators/scrapbook/routes_generator'

RSpec.describe Scrapbook::RoutesGenerator do
  def regex_for_path(url_path)
    /^\s*if Rails\.env\.development\?\s+mount Scrapbook::Engine => '#{url_path}'\s+end$/
  end

  before { prepare_routes_file }

  describe '#routes' do
    it 'mounts the scrapbook engine route for the developement environment at the default path of "/scrapbook"' do
      run_generator(:routes)

      expect(relative_pathname('config/routes.rb').read)
        .to match(regex_for_path('/scrapbook'))
    end

    context 'when specifiying the URL path' do
      it 'uses the specified path for the mount path' do
        run_generator(:routes, '/bookit')

        expect(relative_pathname('config/routes.rb').read)
          .to match(regex_for_path('/bookit'))
      end

      it 'prepends a slash if the argument is missing it' do
        run_generator(:routes, 'bookit')

        expect(relative_pathname('config/routes.rb').read)
          .to match(regex_for_path('/bookit'))
      end
    end
  end
end
