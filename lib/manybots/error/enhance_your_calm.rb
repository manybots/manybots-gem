require 'manybots/error/client_error'

module Manybots
  # Raised when Manybots returns the HTTP status code 420
  class Error::EnhanceYourCalm < Manybots::Error::ClientError
    # The number of seconds your application should wait before requesting date from the Search API again
    #
    # @see http://dev.twitter.com/pages/rate-limiting
    def retry_after
      @http_headers.values_at('retry-after', 'Retry-After').detect{|value| value }.to_i
    end
  end
end
