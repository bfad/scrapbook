# frozen_string_literal: true

RSpec.shared_context 'configure scrapcook' do # rubocop:disable RSpec/ContextWording
  before do
    allow(::Scrapbook::Engine.config.scrapbook).to receive(:paths)
      .and_return(Rails.application.config.scrapbook.paths + [Rails.root.join('scrapcook')])
    Rails.application.reload_routes!
  end
end
