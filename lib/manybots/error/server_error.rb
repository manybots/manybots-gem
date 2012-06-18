require 'manybots/error'

module Manybots
  # Raised when Manybots returns a 5xx HTTP status code
  class Error::ServerError < Manybots::Error
  end
end
