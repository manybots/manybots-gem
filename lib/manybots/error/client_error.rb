require 'manybots/error'

module Manybots
  # Raised when Manybots returns a 4xx HTTP status code
  class Error::ClientError < Manybots::Error
  end
end
