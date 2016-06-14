module Garrison
  class RouteCheckerAbstract
    attr_reader :user, :request

    def initialize(user, request)
      @user = user
      @request = request
    end

    def method_missing(*)
      false
    end
  end
end