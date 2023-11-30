# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scrapbook::PagesHelper do
  describe '#sb' do
    context 'when the controller does not define the scrapbook or pathname methods' do
      it 'raises an error about a missing method' do
        expect { helper.sb }.to raise_error(NoMethodError)
      end
    end

    context 'when the controller defines both `#scrapbook` and `#pathname` methods' do
      before do
        helper.controller.define_singleton_method(:scrapbook) do
          Scrapbook::Scrapbook.new(Pathname.new('/tmp'))
        end

        helper.controller.define_singleton_method(:pathname) do
          Pathname.new('/tmp')
        end
      end

      it 'returns an instance of `HelperForTemplateView`' do
        expect(helper.sb).to be_a(Scrapbook::HelperForTemplateView)
      end
    end
  end
end
