class TestApp
  module Components
    module LoginServer
      def login_user request
        if login(User, request[:username], request[:password])
          {
            success: true
          }
        else
          {
            success: false,
            errors: { username: ['Invalid Username or Password.'] }
          }
        end
      end

      def register_user request
        user = User.create({
          username: request["username"],
          password: request["password"],
          email: request["email"],
          phone_number: request["phone_number"]
        })

        if user.errors.any?
          {
            success: false, errors: user.errors
          }
        else
          {
            success: true
          }
        end
      end
    end
  end
end
