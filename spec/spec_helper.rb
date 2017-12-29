# frozen_string_literal: true

require 'bundler'

Bundler.require :default, :development

Combustion.initialize! :action_controller, :action_view

require 'rspec/rails'

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
