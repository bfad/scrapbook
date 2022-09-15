# frozen_string_literal: true

require 'rails_helper'
require 'generators/scrapbook/routes_generator'

RSpec.describe Scrapbook::RoutesGenerator do
  def regex_for_scrapbook(name)
    /^\s*scrapbook\('#{name}'\)\s+if Rails\.env\.development\?\s+end$/
  end

  before { prepare_routes_file }

  describe '#routes' do
    it 'adds the `extend` and `scrapbook` calls with the default name of "scrapbook"' do
      run_generator(:routes)

      expect(relative_pathname('config/routes.rb').read)
        .to match(regex_for_scrapbook('scrapbook'))
      expect(relative_pathname('config/routes.rb').read)
        .to include('extend Scrapbook::Routing')
    end

    it 'adds the `scrapbook` call with the specified name' do
      run_generator(:routes, 'bookit')

      expect(relative_pathname('config/routes.rb').read)
        .to match(regex_for_scrapbook('bookit'))
      expect(relative_pathname('config/routes.rb').read)
        .to include('extend Scrapbook::Routing')
    end

    context 'when the "extend" call already exists' do
      before do
        relative_pathname('config/routes.rb')
          .write("Rails.application.routes.draw do\n  extend Scrapbook::Routing\nend")
      end

      it "doesn't add an additional extend line" do
        run_generator(:routes)

        extend_count = relative_pathname('config/routes.rb').read
          .scan(/(?=extend Scrapbook::Routing)/).count

        expect(extend_count).to be 1
      end
    end
  end
end
