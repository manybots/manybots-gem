require 'faraday'
require 'multi_json'

module Manybots
  module Response
    class ParseJson < Faraday::Response::Middleware
      
      def parse(body)
        case body
        when ''
          nil
        when 'true'
          true
        when 'false'
          false
        else
          ::MultiJson.decode(body)
        end
      end

    end
  end
end
