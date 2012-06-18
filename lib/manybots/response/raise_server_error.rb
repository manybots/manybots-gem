require 'faraday'
require 'manybots/error/bad_gateway'
require 'manybots/error/internal_server_error'
require 'manybots/error/service_unavailable'

module Manybots
  module Response
    class RaiseServerError < Faraday::Response::Middleware

      def on_complete(env)
        case env[:status].to_i
        when 500
          raise Manybots::Error::InternalServerError.new("Something is technically wrong.", env[:response_headers])
        when 502
          raise Manybots::Error::BadGateway.new("Manybots is down or being upgraded.", env[:response_headers])
        when 503
          raise Manybots::Error::ServiceUnavailable.new("(__-){ Manybots is over capacity.", env[:response_headers])
        end
      end

    end
  end
end
