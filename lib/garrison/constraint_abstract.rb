module Garrison
  class ConstraintAbstract
    def matches?(request)
      for_guard ? check_for_guard(user, request) : check!(user, request)
    end

    private

    def user
      raise ImplementRequired
    end

    def for_guard
      false
    end

    def check!(user, request)
      ConstraintProxy.new(user, request).check!
    end

    def check_for_guard(user, request)
      ConstraintProxy.new(user, request, blocking: true).check!
    end
  end
end