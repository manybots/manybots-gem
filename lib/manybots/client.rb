require 'manybots/authenticatable'
require 'manybots/config'
require 'manybots/connection'
require 'manybots/request'
require 'manybots/user'

module Manybots
  # Wrapper for the Manybots REST API
  #
  # @note All methods have been separated into modules and follow the same grouping used in {http://www.manybots.com/api the Manybots API Documentation}.
  # @see http://www.manybots.com/developer
  class Client

    include Manybots::Authenticatable
    include Manybots::Connection
    include Manybots::Request

    require 'manybots/client/users'
    include Manybots::Client::Users

    attr_accessor *Config::VALID_OPTIONS_KEYS

    # Initializes a new API object
    #
    # @param attrs [Hash]
    # @return [Manybots::Client]
    def initialize(attrs={})
      attrs = Manybots.options.merge(attrs)
      Config::VALID_OPTIONS_KEYS.each do |key|
        instance_variable_set("@#{key}".to_sym, attrs[key])
      end
    end

    # Returns the configured screen name or the screen name of the authenticated user
    #
    # @return [Manybots::User]
    def current_user
      @current_user ||= Manybots::User.new(self.verify_credentials)
    end

  end
end
