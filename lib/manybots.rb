require 'manybots/client'
require 'manybots/config'

module Manybots
  extend Config
  class << self
    # Alias for Manybots::Client.new
    #
    # @return [Manybots::Client]
    def new(options={})
      Manybots::Client.new(options)
    end

    # Delegate to Manybots::Client
    #    def method_missing(method, *args, &block)
    #  return super unless new.respond_to?(method)
    #  new.send(method, *args, &block)
    #end

    def respond_to?(method, include_private=false)
      new.respond_to?(method, include_private) || super(method, include_private)
    end
  end
end
