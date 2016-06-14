module Garrison
  class ConstraintProxy
    def initialize(user, request, blocking: false)
      @user = user
      @request = request
      @action = request.params['action']
      @controller =request.params['controller']
      @blocking = blocking
    end

    def checker
      "#{@controller.camelize}RouteChecker".gsub('::', '').constantize
    end

    def check_method
      if @blocking
        "block_#{@action.to_s.gsub('!', '')}?"
      else
        "can_#{@action.to_s.gsub('!', '')}?"
      end
    end

    def check!
      checker.new(@user, @request).send(check_method)
    end
  end
end