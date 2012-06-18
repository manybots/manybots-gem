require 'manybots/error/client_error'

module Manybots
  # Raised when Manybots returns the HTTP status code 403
  class Error::Forbidden < Manybots::Error::ClientError
  end
end
