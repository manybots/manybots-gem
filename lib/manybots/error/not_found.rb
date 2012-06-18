require 'manybots/error/client_error'

module Manybots
  # Raised when Manybots returns the HTTP status code 404
  class Error::NotFound < Manybots::Error::ClientError
  end
end
