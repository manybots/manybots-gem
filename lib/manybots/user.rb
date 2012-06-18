require 'active_support/core_ext/hash/except'
require 'manybots/authenticatable'
require 'manybots/base'
require 'manybots/creatable'

module Manybots
  class User < Manybots::Base
    include Manybots::Authenticatable
    include Manybots::Creatable

    # @param other [Manybots::User]
    # @return [Boolean]
    def ==(other)
      super || (other.class == self.class && other.id == self.id)
    end

    # @param consumer_key [String]
    # @param consumer_secret [String]
    # @param endpoint [String]
    def manybots_client(consumer_key, consumer_secret, endpoint)
      consumer ||= OAuth::Consumer.new(consumer_key, consumer_secret, {
        :site => endpoint
      })
      access_token = OAuth::AccessToken.new(consumer, self.manybots_token, self.manybots_secret)
    end

    def post_to_manybots!(activity)
      result = self.manybots_client.post("#{MANYBOTS_URL}/activities.json", 
        {:version => '1.0', :activity => activity}.to_json, 
        {'Content-Type' => 'application/json', 'Accept' => 'application/json'}
      )
      Manybots::Feed::Item.from_json result.body
    end
    
    def recent_manybots_activities
      result = self.manybots_client.get('/activities.json')
      Manybots::Feed.from_json(result.body).entries
    end
    
  end
end
