require_relative '../../forms/login'
require_relative '../../forms/registration'

if RUBY_ENGINE == 'opal'
  class Element
    alias_native :mask
  end
end

class TestApp
  module Components
    class Login < Wedge::Component
      name :login

      on :ready do
        dom.find('input[type="tel"]').mask '(999) 999 - 9999'
      end

      on :click, '.toggle' do
        @this.children('i').toggle_class 'fa-pencil'

        dom.find('.form').animate(
          height: 'toggle',
          'padding-top' => 'toggle',
          'padding-bottom' => 'toggle',
          opacity: 'toggle'
        )
      end

      on :submit, '#login-form', form: :login_form, key: :user do |form, el|
        button = el.find('button[type="submit"]')
        button.prop("disabled", true)

        begin
          if form.valid?
            login_user form.attributes do |res|
              if res[:success]
                redirect_root
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

      on :submit, '#registration-form', form: :registration_form, key: :user do |form, el|
        button = el.find('button[type="submit"]')
        button.prop("disabled", true)

        begin
          if form.valid?
            register_user form.attributes do |res|
              if res[:success]
                redirect_root
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

      def redirect_root
        `window.location.replace('/')`
      end
    end
  end
end
