ENV['RACK_ENV'] = 'test'

require 'capybara/rspec'
require 'capybara/poltergeist'
require_relative "../app"

Capybara.default_driver = :poltergeist
Capybara.app = TestApp
Bundler.require(:default, :test)

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.after(:each) do |example|
    if example.exception
      meta = example.metadata
      filename = File.basename(meta[:file_path])
      line_number = meta[:line_number]
      screenshot_name = "screenshot-#{filename}-#{line_number}.png"
      screenshot_path = "#{Dir.pwd}/tmp/#{screenshot_name}"

      page.save_screenshot(screenshot_path)

      puts meta[:full_description] + "\n  Screenshot: #{screenshot_path}"
    end
  end
end
