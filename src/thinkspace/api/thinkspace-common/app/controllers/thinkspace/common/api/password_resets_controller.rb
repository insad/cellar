module Thinkspace
  module Common
    module Api
      class PasswordResetsController < Totem::Settings.class.thinkspace.authorization_api_controller
        before_action :set_password_reset_class

        def create
          permission_denied('No email in params.') unless params_root.has_key?(:email) && params_root[:email].present?
          params_email   = params_root[:email].strip.downcase
          password_reset = @password_reset_class.find_by(email: params_email)
          if password_reset.present? # resend email if password_reset present
            password_reset.send_instructions
            return controller_render_no_content
          end
          response = ::Totem::Settings.oauth.current_get_password_reset_token(self, email: params_email)

          # Must be a blank return here or else could leak email validity information.
          unless response['valid']
            @password_reset_class.notify_user_not_found(params_email)
            return controller_render_no_content
          end

          token          = response['token']
          email          = response['email']
          password_reset = @password_reset_class.create(token: token, email: email)
          password_reset.send_instructions
          # Do NOT render the model to the client.  This would cause major security issues.
          controller_render_no_content
        end

        def show
          # params: { id: 'token-here' } # Note: the `id` is the token in this instance.
          token                          = params[:id]
          password_reset                 = @password_reset_class.find_by(token: token)
          password_reset.present? ? json = controller_as_json(password_reset) : json = controller_as_json(generate_fake_model(token))
          controller_render_json(json)
        end

        def update
          token          = params_root[:token]
          password       = params_root[:password]

          # Check for the ID, if it is not found, return a fake model.
          password_reset = @password_reset_class.find_by(token: token)
          return controller_render(generate_fake_model(token)) unless password_reset.present?

          email = password_reset.email
          permission_denied('Invalid request.')  unless password_reset.token == params_root[:token]
          permission_denied('Invalid password.') unless password.present? # params_root checks this, but just in case it changes.

          response = ::Totem::Settings.oauth.current_set_password_from_token(self, email: email, password: password, token: token)
          # if this returns an error, render 423
          if response['errors'].present?
            permission_denied(get_message_for_error(response['errors'])) 
          else
            controller_render(password_reset) if password_reset.destroy
          end
        end

        private

        def get_message_for_error(errors)
          attribute, message = errors.first
          case attribute
          when 'reset_password_token'
            return 'The password reset window has expired.'
          else
            return 'There was a problem trying to reset your password.'
          end
        end

        def permission_denied(message='Cannot access this resource.', options={})
          action = options[:action] ||= :unknown
          options[:user_message] = message
          raise_access_denied_exception(message, action, nil, options)
        end

        def error_json(message)
          render json: { errors: [message] }
        end

        def generate_fake_model(token)
          id  = token.hash.abs.to_s.first(3)
          @password_reset_class.new(id: id, token: token)
        end

        def set_password_reset_class; @password_reset_class = ::Totem::Settings.authentication.current_model_class(self, :password_reset_model); end

      end
    end
  end
end
