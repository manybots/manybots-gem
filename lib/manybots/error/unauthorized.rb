require 'manybots/error/client_error'

module Manybots
  # Raised when Manybots returns the HTTP status code 401
  class Error::Unauthorized < Manybots::Error::ClientError
  end
end
