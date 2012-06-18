require 'manybots/error/server_error'

module Manybots
  # Raised when Manybots returns the HTTP status code 502
  class Error::BadGateway < Manybots::Error::ServerError
  end
end
