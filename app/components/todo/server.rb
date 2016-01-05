class TestApp
  module Components
    module TodoServer
      def save_task request
        task = Task.create({
          description: request["description"],
          category: request["category"],
          due_date: request["due_date"],
        })

        current_user.add_task task

        if task.errors.any?
          {
            success: false, errors: task.errors
          }
        else
          {
            success: true,
            task: {
              id: task.id,
              category: task.category,
              description: task.description,
              due_date: task.due_date
            }
          }
        end
      end

      def get_tasks show_all = false
        tasks = show_all ? Task : current_user.tasks
        {
          tasks: tasks.map do |task|
            {
              id: task.id,
              category: task.category,
              description: task.description,
              due_date: task.due_date,
              complete: task.complete,
            }
          end
        }
      end

      def delete_tasks task_ids
        if current_user.tasks_dataset.where(id: task_ids).delete
          {
            success: true
          }
        end
      end

      def mark_as_complete task_ids
        tasks = current_user.tasks_dataset.where(id: task_ids)
        tasks.each do |task|
          task.complete = true
          task.save
        end

        if tasks.errors.any?
          {
            success: false, errors: tasks.errors
          }
        else
          {
            success: true,
          }
        end
      end
    end
  end
end
