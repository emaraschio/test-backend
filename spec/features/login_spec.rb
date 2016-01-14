require 'spec_helper'
require 'features_helper'

describe "Login", :type => :feature do
  describe "GET /login" do
    before(:all) do
      @credentials = {
        username: 'rspec',
        password: 'rspec',
        email: 'rspec@rspec.com',
        phone_number: '123 1234 1234'
      }
      @user = User.create(@credentials)
    end

    after(:all) do
      @user.destroy
    end

    it "should login user" do
      sign_in(@credentials[:username], @credentials[:password]) && delay_test
      expect(page).to have_current_path('/')
    end

    it "should logout user" do
      sign_in(@credentials[:username], @credentials[:password]) && delay_test
      visit('/logout') && delay_test
      expect(page).to have_current_path('/login')
    end

    it "should redirect to login if the user is not logged in" do
      visit('/')
      expect(page).to have_current_path('/login')
    end
  end
end
