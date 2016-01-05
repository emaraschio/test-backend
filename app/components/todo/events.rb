require_relative '../../forms/task'

if RUBY_ENGINE == 'opal'
  class Element
    alias_native :datepicker
  end
end

class TestApp
  module Components
    class Todo < Wedge::Component
      name :todo

      on :ready do
        dom.find('input.taskDate').datepicker(`{dateFormat: 'dd/mm/yy'}`)

        get_tasks do |res|
          res[:tasks].each do |task|
            add_task task[:id], task[:description], task[:category], task[:due_date], task[:complete]
          end
        end
      end

      on :submit, '#task-form', form: :task_form, key: :task do |form, el|
        button = el.find('button[type="submit"]')
        button.prop("disabled", true)

        begin
          if form.valid?
            save_task form.attributes do |res|
              if res[:success]
                add_task res[:task][:id], res[:task][:description], res[:task][:category], res[:task][:due_date]
                clear_fields el
              else
                form.display_errors errors: res[:errors]
              end
            end
          else
            form.display_errors
          end
        ensure
          button.prop("disabled", false)
        end
      end

      on :click, '.taskDelete' do |el, e|
        e.prevent_default
        tasks_ids = []
        checked_tasks = dom.find('.taskCheckbox[type=checkbox]:checked')
        checked_tasks.each do |checked_task|
          tasks_ids << checked_task.closest('.taskItem')
                                  .attr('class')
                                  .split('task-id-')[1]
        end
        delete_tasks tasks_ids do |res|
          checked_tasks.closest('.taskItem').remove if res[:success]
        end
      end

      on :click, '.taskComplete' do |el, e|
        e.prevent_default
        tasks_ids = []
        checked_tasks = dom.find('.taskCheckbox[type=checkbox]:checked')
        checked_tasks.each do |checked_task|
          tasks_ids << checked_task.closest('.taskItem')
                                  .attr('class')
                                  .split('task-id-')[1]
        end
        mark_as_complete tasks_ids do |res|
          if res[:success]
            task_item = checked_tasks.closest('.taskItem')
            description_dom = task_item.find('.description')
            description_dom.add_class "complete-true"
            description_dom = task_item.find('.date')
            description_dom.add_class "complete-true"
          end
        end
      end

      on :click, '.allTasks' do |el|
        clean_all_tasks

        get_tasks true do |res|
          res[:tasks].each do |task|
            add_task task[:id], task[:description], task[:category], task[:due_date], task[:complete]
          end
        end
      end

      on :click, '.myTasks' do |el|
        clean_all_tasks

        get_tasks do |res|
          res[:tasks].each do |task|
            add_task task[:id], task[:description], task[:category], task[:due_date], task[:complete]
          end
        end
      end

      def clean_all_tasks
        dom.find('.taskItem').remove
      end

    end
  end
end
