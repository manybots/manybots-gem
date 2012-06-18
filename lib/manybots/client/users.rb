require 'manybots/core_ext/hash'
require 'manybots/error/not_found'
require 'manybots/user'

module Manybots
  class Client
    # Defines methods related to users
    module Users

      def post_test_activity(user=nil)
        Manybots::Feed.Item.new_test_activity(user)
      end
      # Returns extended information for up to 100 users
      #
      # @see https://dev.manybots.com/docs/api/1/get/users/lookup
      # @rate_limited Yes
      # @requires_authentication Yes
      # @overload users(*users, options={})
      #   @param users [Array<Integer, String>, Set<Integer, String>] Manybots user IDs or screen names.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :include_entities Include {https://dev.manybots.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      #   @raise [Manybots::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @return [Array<Manybots::User>] The requested users.
      #   @raise [Manybots::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example Return extended information for @sferik and @pengwynn
      #     Manybots.users("sferik", "pengwynn")
      #     Manybots.users("sferik", 14100886)   # Same as above
      #     Manybots.users(7505382, 14100886)    # Same as above
      def users(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        users = args
        options.merge_users!(Array(users))
        get("/1/users/lookup.json", options).map do |user|
          Manybots::User.new(user)
        end
      end

      # Returns users that match the given query
      #
      # @see https://dev.manybots.com/docs/api/1/get/users/search
      # @rate_limited Yes
      # @requires_authentication Yes
      # @param query [String] The search query to run against people search.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :per_page The number of people to retrieve. Maxiumum of 20 allowed per page.
      # @option options [Integer] :page Specifies the page of results to retrieve.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.manybots.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Array<Manybots::User>]
      # @raise [Manybots::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example Return users that match "Erik Michaels-Ober"
      #   Manybots.user_search("Erik Michaels-Ober")
      def user_search(query, options={})
        get("/1/users/search.json", options.merge(:q => query)).map do |user|
          Manybots::User.new(user)
        end
      end

      # Returns extended information of a given user
      #
      # @see https://dev.manybots.com/docs/api/1/get/users/show
      # @rate_limited Yes
      # @requires_authentication No
      # @overload user(user, options={})
      #   @param user [Integer, String] A Manybots user ID or screen name.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :include_entities Include {https://dev.manybots.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      #   @return [Manybots::User] The requested user.
      #   @example Return extended information for @sferik
      #     Manybots.user("sferik")
      #     Manybots.user(7505382)  # Same as above
      def user(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        if user = args.pop
          options.merge_user!(user)
          user = get("/1/users/show.json", options)
        else
          user = get("/1/account/verify_credentials.json", options)
        end
        Manybots::User.new(user)
      end

      # Returns true if the specified user exists
      #
      # @param user [Integer, String] A Manybots user ID or screen name.
      # @return [Boolean] true if the user exists, otherwise false.
      # @example Return true if @sferik exists
      #     Manybots.user?("sferik")
      #     Manybots.user?(7505382)  # Same as above
      # @requires_authentication No
      # @rate_limited Yes
      def user?(user, options={})
        options.merge_user!(user)
        get("/1/users/show.json", options, :raw => true)
        true
      rescue Manybots::Error::NotFound
        false
      end

      # Returns an array of users that the specified user can contribute to
      #
      # @see http://dev.manybots.com/docs/api/1/get/users/contributees
      # @rate_limited Yes
      # @requires_authentication No unless requesting it from a protected user
      #
      #   If getting this data of a protected user, you must authenticate (and be allowed to see that user).
      # @overload contributees(options={})
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :include_entities Include {http://dev.manybots.com/pages/tweet_entities Tweet Entities} when set to true, 't' or 1.
      #   @option options [Boolean, String, Integer] :skip_status Do not include contributee's statuses when set to true, 't' or 1.
      #   @return [Array<Manybots::User>]
      #   @example Return the authenticated user's contributees
      #     Manybots.contributees
      ## @overload contributees(user, options={})
      #   @param user [Integer, String] A Manybots user ID or screen name.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :include_entities Include {http://dev.manybots.com/pages/tweet_entities Tweet Entities} when set to true, 't' or 1.
      #   @option options [Boolean, String, Integer] :skip_status Do not include contributee's statuses when set to true, 't' or 1.
      #   @return [Array<Manybots::User>]
      #   @example Return users @sferik can contribute to
      #     Manybots.contributees("sferik")
      #     Manybots.contributees(7505382)  # Same as above
      def contributees(*args)
        options = {}
        options.merge!(args.last.is_a?(Hash) ? args.pop : {})
        user = args.pop || self.current_user.screen_name
        options.merge_user!(user)
        get("/1/users/contributees.json", options).map do |user|
          Manybots::User.new(user)
        end
      end

      # Returns an array of users who can contribute to the specified account
      #
      # @see http://dev.manybots.com/docs/api/1/get/users/contributors
      # @rate_limited Yes
      # @requires_authentication No unless requesting it from a protected user
      #
      #   If getting this data of a protected user, you must authenticate (and be allowed to see that user).
      # @overload contributors(options={})
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :include_entities Include {http://dev.manybots.com/pages/tweet_entities Tweet Entities} when set to true, 't' or 1.
      #   @option options [Boolean, String, Integer] :skip_status Do not include contributee's statuses when set to true, 't' or 1.
      #   @return [Array<Manybots::User>]
      #   @example Return the authenticated user's contributors
      #     Manybots.contributors
      ## @overload contributors(user, options={})
      #   @param user [Integer, String] A Manybots user ID or screen name.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :include_entities Include {http://dev.manybots.com/pages/tweet_entities Tweet Entities} when set to true, 't' or 1.
      #   @option options [Boolean, String, Integer] :skip_status Do not include contributee's statuses when set to true, 't' or 1.
      #   @return [Array<Manybots::User>]
      #   @example Return users who can contribute to @sferik's account
      #     Manybots.contributors("sferik")
      #     Manybots.contributors(7505382)  # Same as above
      def contributors(*args)
        options = {}
        options.merge!(args.last.is_a?(Hash) ? args.pop : {})
        user = args.pop || self.current_user.screen_name
        options.merge_user!(user)
        get("/1/users/contributors.json", options).map do |user|
          Manybots::User.new(user)
        end
      end

      # Returns recommended users for the authenticated user
      #
      # @note {https://dev.manybots.com/discussions/1120 Undocumented}
      # @rate_limited Yes
      # @requires_authentication Yes
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :limit (20) Specifies the number of records to retrieve.
      # @option options [String] :excluded Comma-separated list of user IDs to exclude.
      # @option options [String] :screen_name Find users similar to this screen_name
      # @option options [Integer] :user_id Find users similar to this user ID.
      # @return [Array<Manybots::User>]
      # @raise [Manybots::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example Return recommended users for the authenticated user
      #   Manybots.recommendations
      def recommendations(options={})
        options[:excluded] = options[:excluded].join(',') if options[:excluded].is_a?(Array)
        get("/1/users/recommendations.json", options).map do |recommendation|
          Manybots::User.new(recommendation['user'])
        end
      end

    end
  end
end
