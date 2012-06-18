require 'manybots/error/server_error'

module Manybots
  # Raised when Manybots returns the HTTP status code 503
  class Error::ServiceUnavailable < Manybots::Error::ServerError
  end
end
