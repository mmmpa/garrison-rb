module Garrison
  class CheckerAbstract
    attr_reader :user, :obj

    def initialize(user, obj)
      @user = user
      @obj = obj
    end

    def can_read?
      raise RequireImplement
    end

    def can_write?
      raise RequireImplement
    end
  end
end