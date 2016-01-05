class TestApp
  module Forms
    class Task < Wedge::Plugins::Form
      name :task_form

      attr_accessor :description, :category, :due_date

      def validate
        assert_present :description
        assert_present :category
        assert_present :due_date
      end
    end
  end
end
