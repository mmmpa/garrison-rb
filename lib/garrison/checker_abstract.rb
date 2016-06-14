module Garrison
  class CheckerAbstract
    attr_reader :user, :obj

    def initialize(user, obj)
      @user = user
      @obj = obj
    end

    def deny_all
      true
    end

    def method_missing(*)
      !deny_all
    end
  end
end