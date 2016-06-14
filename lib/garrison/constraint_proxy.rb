module Garrison
  class ConstraintProxy
    def initialize(user, request)
      @user = user
      @request = request
    end

    def checker
      @request
      "#{@request.class.name}RouteChecker".gsub('::', '').constantize
    end

    def check_method
      @request
    end

    def check!
      raise Forbidden unless checker.new(@user, @request).send(check_method)
    end
  end
end