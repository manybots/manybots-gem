require 'manybots/error/server_error'

module Manybots
  # Raised when Manybots returns the HTTP status code 500
  class Error::InternalServerError < Manybots::Error::ServerError
  end
end
