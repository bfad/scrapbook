# frozen_string_literal: true

require 'active_support/testing/stream'

module GeneratorHelpers
  include ActiveSupport::Testing::Stream

  def self.included(base)
    base.let(:destination) { Pathname.new(Rails.root).expand_path + "tmp/generators_test/#{SecureRandom.uuid}" }
    base.subject(:generator) { described_class.new([], {}, destination_root: destination) }

    base.around do |example|
      destination.mkpath
      example.run
    ensure
      # Make sure to remove even if exiting from a debugger
      destination.rmtree
    end
  end

  def run_generator(task, *args, **options)
    capture(:stdout) do
      generator.invoke(task, args, options)
    end
  end

  def relative_pathname(path_relative_to_destination)
    destination + path_relative_to_destination
  end

  def prepare_routes_file
    routes_pathname = relative_pathname('config/routes.rb')
    routes_pathname.dirname.mkpath
    routes_pathname.write("Rails.application.routes.draw do\nend")
  end
end
