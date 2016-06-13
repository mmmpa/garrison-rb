module Garrison
  class CheckerAbstract
    attr_reader :user, :obj

    def initialize(user, obj)
      @user = user
      @obj = obj
    end

    def method_missing(*)
      false
    end
  end
end