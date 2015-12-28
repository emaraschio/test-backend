class TestApp
  module Forms
    class Registration < Wedge::Plugins::Form
      name :registration_form

      attr_accessor :username, :password, :email, :phone_number

      def validate
        assert_present :username
        assert_present :password
        assert_present :phone_number
        assert_present :email
        assert_email :email
        assert_format :phone_number, /\(\d{3}\) \d{3} - \d{4}/
      end
    end
  end
end
