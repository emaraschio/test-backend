require 'spec_helper'
require 'features_helper'

describe "Registration", :type => :feature do
  before(:each) do
    @credentials = {
      username: 'rspec_registration_form',
      password: 'rspec_registration_form',
      email: 'rspec_registration_form@rspec.com',
      phone_number: '123 1234 1234'
    }

    visit "/login"
    find('i.fa-pencil').click
  end

  after(:each) do
    User.where(username: @credentials[:username]).destroy
  end

  it "should fail if some fields are not filled" do
    find('#registration-form').fill_in('user[username]', :with => '')
    find('#registration-form').fill_in('user[password]', :with => '')
    find('#registration-form').fill_in('user[email]', :with => @credentials[:email])
    find('#registration-form').fill_in('user[phone_number]', :with => @credentials[:phone_number])

    click_button 'Register'

    expect(find('#registration-form')).to have_content('Required')
  end

  it "should register a new user" do
    expect(find('h2')).to have_content('Create an account')
    find('#registration-form').fill_in('user[username]', :with => @credentials[:username])
    find('#registration-form').fill_in('user[password]', :with => @credentials[:password])
    find('#registration-form').fill_in('user[email]', :with => @credentials[:email])
    find('#registration-form').fill_in('user[phone_number]', :with => @credentials[:phone_number])

    click_button 'Register'

    sign_in(@credentials[:username], @credentials[:password])
    expect(page).to have_current_path('/')
  end



end
