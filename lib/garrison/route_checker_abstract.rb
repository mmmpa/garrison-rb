module Garrison
  class RouteCheckerAbstract
    attr_reader :user, :request

    def initialize(user, request)
      @user = user
      @request = request
    end

    def deny_all
      true
    end

    def method_missing(*)
      !deny_all
    end
  end
end