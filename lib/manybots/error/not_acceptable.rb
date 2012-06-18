require 'manybots/error/client_error'

module Manybots
  # Raised when Manybots returns the HTTP status code 406
  class Error::NotAcceptable < Manybots::Error::ClientError
  end
end
