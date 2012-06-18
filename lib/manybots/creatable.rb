require 'time'

module Manybots
  module Creatable

    # Time when the object was created on Manybots
    #
    # @return [Time]
    def created_at
      @created_at ||= Time.parse(@attrs['created_at']) unless @attrs['created_at'].nil?
    end

  end
end
