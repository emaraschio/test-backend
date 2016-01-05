require 'capybara/poltergeist'

Capybara.configure do |config|
  config.javascript_driver = :poltergeist
end

def sign_in(username, password)
  visit('/login')
  fill_in('user[username]', :with => username)
  fill_in('user[password]', :with => password)
  click_button 'Login'
  delay_test
end

def delay_test
  Timeout.timeout(Capybara.default_max_wait_time) do
    loop until page.evaluate_script('jQuery.active').zero?
  end
end
