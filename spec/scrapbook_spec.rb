# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scrapbook do
  it 'has a version number' do
    expect(Scrapbook::VERSION).to be_present
  end
end
