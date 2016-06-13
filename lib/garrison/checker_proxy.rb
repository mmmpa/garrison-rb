module Garrison
  class CheckerProxy
    def initialize(user, obj, doing)
      @user = user
      @obj = obj
      @doing = doing
    end

    def checker
      # for instance
      "#{@obj.class.name}Checker".gsub('::', '').constantize
    rescue
      # for Class
      "#{@obj.name}ClassChecker".gsub('::', '').constantize
    end

    def check_method
      "can_#{@doing.to_s.gsub('!', '')}?"
    end

    def check!
      raise Forbidden unless checker.new(@user, @obj).send(check_method)
    end
  end
end