require 'spec_helper'
require 'features_helper'

describe "Tasks", :type => :feature do
  before(:all) do
    credentials = {
      username: 'test',
      password: 'test',
      email: 'test@rspec.com',
      phone_number: '123 444 1231'
    }
    task_info = {
      description: 'Rspec Task 1',
      category: 'personal',
      due_date: Date.today
    }
    @user = User.create(credentials)
    @task = @user.add_task(task_info)
  end

  before(:each) do
    sign_in && delay_test
    visit('/')
  end

  after(:all) do
    @task.destroy
    @user.destroy
  end

  it "should display all action buttons" do
    expect(page).to have_current_path('/')
    find('button.taskAdd')
    find('button.taskDelete')
    find('button.taskComplete')
    find('button.allTasks')
    find('button.myTasks')
  end

  it "should mark all tasks as complete" do
    expect(page).to have_current_path('/')
    find('.taskCheckbox').click
    find('.taskComplete').click && delay_test

    expect(page).to have_selector('.complete-true')
  end

  it "should create a new task" do
    expect(page).to have_current_path('/')

    fill_in('task[description]', with: 'A new task from specs' )
    select 'Personal', from: 'task[category]'
    fill_in('task[due_date]', with: '01/01/2016' )

    click_button('Add task') && delay_test

    expect(page).to have_content('A new task from specs')
    expect(page).to have_content('PERSONAL')
  end

  it "should display my tasks" do
    expect(page).to have_current_path('/')
    expect(page).to have_content('Rspec Task 1')
    expect(page).to have_content('PERSONAL')
  end

  describe "Other user stuff" do
    before(:each) do
      @other_user = User.create({
        username: 'test_2',
        password: 'test_2',
        email: 'test_2@rspec.com',
        phone_number: '123 333 1231'
      })
      other_task_info = {
        description: 'Rspec Other User Task 1',
        category: 'personal',
        due_date: Date.today
      }
      @other_task = @other_user.add_task(other_task_info)
    end

    after(:each) do
      @other_task.destroy
      @other_user.destroy
    end

    it "should display other user tasks" do
      click_button 'All Tasks'

      expect(page).to have_content('Rspec Other User Task 1')
      expect(page).to have_content('PERSONAL')
    end
  end
end
