require 'manybots/error/client_error'

module Manybots
  # Raised when Manybots returns the HTTP status code 400
  class Error::BadRequest < Manybots::Error::ClientError
  end
end
