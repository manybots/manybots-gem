require 'faraday'
require 'manybots/error/bad_request'
require 'manybots/error/enhance_your_calm'
require 'manybots/error/forbidden'
require 'manybots/error/not_acceptable'
require 'manybots/error/not_found'
require 'manybots/error/unauthorized'

module Manybots
  module Response
    class RaiseClientError < Faraday::Response::Middleware

      def on_complete(env)
        case env[:status].to_i
        when 400
          raise Manybots::Error::BadRequest.new(error_body(env[:body]), env[:response_headers])
        when 401
          raise Manybots::Error::Unauthorized.new(error_body(env[:body]), env[:response_headers])
        when 403
          raise Manybots::Error::Forbidden.new(error_body(env[:body]), env[:response_headers])
        when 404
          raise Manybots::Error::NotFound.new(error_body(env[:body]), env[:response_headers])
        when 406
          raise Manybots::Error::NotAcceptable.new(error_body(env[:body]), env[:response_headers])
        when 420
          raise Manybots::Error::EnhanceYourCalm.new(error_body(env[:body]), env[:response_headers])
        end
      end

    private

      def error_body(body)
        if body.nil?
          ''
        elsif body['error']
          body['error']
        elsif body['errors']
          first = Array(body['errors']).first
          if first.kind_of?(Hash)
            first['message'].chomp
          else
            first.chomp
          end
        end
      end

    end
  end
end
