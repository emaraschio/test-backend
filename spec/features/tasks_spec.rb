require 'spec_helper'
require 'features_helper'

describe "Tasks", :type => :feature do
  before(:each) do
    @credentials = {
      username: '1d21f',
      password: '13d1',
      email: 'd12d@rspec.com',
      phone_number: '123 444 1231'
    }
    @user = User.create(@credentials)
    @task = @user.add_task({
      description: 'Rspec Task 1',
      category: 'personal',
      due_date: Date.today
    })

    @other_user = User.create({
      username: 'd1d1',
      password: 'd121',
      email: 'd12@rspec.com',
      phone_number: '123 333 1231'
    })
    @other_task = @other_user.add_task({
      description: 'Rspec Other User Task 1',
      category: 'personal',
      due_date: Date.today
    })

    sign_in(@credentials[:username], @credentials[:password])
    visit('/')
  end

  after(:each) do
    @user.destroy
    @other_user.destroy
  end

  it "should mark all tasks as complete" do
    expect(page).to have_current_path('/')
    find('.taskCheckbox').click

    click_button 'Complete Tasks'

    expect(page).to have_selector('.description.complete-true')
  end

  it "should create a new task" do
    expect(page).to have_current_path('/')
    fill_in('task[description]', with: 'A new task from specs' )
    select 'Personal', from: 'task[category]'
    fill_in('task[due_date]', with: '01/01/2016' )

    click_button('Add task')

    expect(page).to have_content('A new task from specs')
    expect(page).to have_content('PERSONAL')
  end

  it "should display my tasks" do
    expect(page).to have_current_path('/')
    expect(page).to have_content(@task.description)
    expect(page).to have_content('PERSONAL')
  end

  it "should display other users tasks" do
    expect(page).to have_current_path('/')
    click_button 'All Tasks'

    expect(page).to have_content(@other_task.description)
    expect(page).to have_content('PERSONAL')
  end
end
