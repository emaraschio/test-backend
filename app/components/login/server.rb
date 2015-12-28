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
    end
  end
end
