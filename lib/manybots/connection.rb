require 'faraday'
require 'manybots/core_ext/hash'
require 'manybots/response/parse_json'
require 'manybots/response/raise_client_error'
require 'manybots/response/raise_server_error'

module Manybots
  module Connection
  private

    # Returns a Faraday::Connection object
    #
    # @param options [Hash] A hash of options
    # @return [Faraday::Connection]
    def connection(options={})
      default_options = {
        :headers => {
          :accept => 'application/json',
          :user_agent => user_agent,
        },
        :ssl => {:verify => false},
        :url => options.fetch(:endpoint, endpoint),
      }
      Faraday.new(default_options) do |builder|
        builder.use Manybots::Request::ManybotsOAuth, credentials if credentials?
        builder.use Faraday::Request::UrlEncoded
        builder.use Faraday::Request::Multipart
        builder.use Manybots::Response::RaiseClientError
        builder.use Manybots::Response::ParseJson unless options[:raw]
        builder.use Manybots::Response::RaiseServerError
        builder.adapter(adapter)
      end
    end

  end
end
