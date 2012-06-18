require 'manybots/version'

module Manybots
  # Defines constants and methods related to configuration
  module Config

    # The endpoint that will be used to connect if none is set
    DEFAULT_ENDPOINT = 'https://www.manybots.com'
    # The auth method if none is set either OAUTH or APIKEY
    DEFAULT_AUTH_METHOD = 'OAUTH'
    
    # The api key if none is set
    DEFAULT_API_KEY = nil
    
    # The consumer key if none is set
    DEFAULT_CONSUMER_KEY = nil
    # The consumer secret if none is set
    DEFAULT_CONSUMER_SECRET = nil

    # The oauth token if none is set
    DEFAULT_OAUTH_TOKEN = nil
    # The oauth token secret if none is set
    DEFAULT_OAUTH_TOKEN_SECRET = nil

    # The value sent in the 'User-Agent' header if none is set
    DEFAULT_USER_AGENT = "Manybots Ruby Gem #{Manybots::Version}"

    # An array of valid keys in the options hash when configuring a {Manybots::Client}
    VALID_OPTIONS_KEYS = [
      :endpoint,
      :authmethod,
      :apikey,
      :consumer_key,
      :consumer_secret,
      :oauth_token,
      :oauth_token_secret,
      :user_agent
    ]

    attr_accessor *VALID_OPTIONS_KEYS

    # When this module is extended, set all configuration options to their default values
    def self.extended(base)
      base.reset
    end

    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self
      self
    end

    # Create a hash of options and their values
    def options
      options = {}
      VALID_OPTIONS_KEYS.each{|k| options[k] = send(k)}
      options
    end

    # Reset all configuration options to defaults
    def reset
      self.endpoint           = DEFAULT_ENDPOINT
      self.authmethod         = DEFAULT_AUTH_METHOD
      self.apikey             = DEFAULT_API_KEY
      self.consumer_key       = DEFAULT_CONSUMER_KEY
      self.consumer_secret    = DEFAULT_CONSUMER_SECRET
      self.oauth_token        = DEFAULT_OAUTH_TOKEN
      self.oauth_token_secret = DEFAULT_OAUTH_TOKEN_SECRET
      self.user_agent         = DEFAULT_USER_AGENT
      self
    end

  end
end
