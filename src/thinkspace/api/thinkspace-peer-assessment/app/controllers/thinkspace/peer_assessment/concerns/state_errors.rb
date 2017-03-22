module Thinkspace; module PeerAssessment; module Concerns;
  # # state_errors
  # - Type: **Concerns**
  # - Engine: **thinkspace-peer-assessment**
  module StateErrors
    def access_denied_state_error(action)
      message      = "Invalid state transition for #{@model_class} to: #{action}, from: #{@model.state}"
      user_message = "You cannot #{action} #{@model_name} in its current state of #{@model.state}."
      raise_access_denied_exception message, action, @model, user_message: user_message
    end
  end
end; end; end;
