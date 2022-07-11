# frozen_string_literal: true

require 'rails_helper'
require 'generators/scrapbook/new_generator'

RSpec.describe Scrapbook::NewGenerator do
  describe '#new' do
    it 'creates the basic folder structure of a scrapbook at the default location of "scrapbook"' do
      run_generator(:new)
      pages_keep_path = relative_pathname('scrapbook/pages/.keep')

      expect(pages_keep_path).to exist
      expect(pages_keep_path.read).to be_empty
    end

    context 'when specifiying a name of a scrapbook' do
      it 'creates a folder with the specified scrapbook name' do
        run_generator(:new, 'bookit')
        expect(relative_pathname('bookit')).to exist
      end

      it 'creates the basic folder structure for the scrapbook' do
        run_generator(:new, 'bookit')
        pages_keep_path = relative_pathname('bookit/pages/.keep')

        expect(pages_keep_path).to exist
        expect(pages_keep_path.read).to be_empty
        expect(relative_pathname('bookit/pages.html.erb').read).to match(/Welcome to Scrapbook/)
      end
    end
  end
end
