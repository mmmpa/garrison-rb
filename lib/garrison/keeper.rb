module Garrison
  class Keeper
    def initialize(user)
      @user = user
    end

    def read(obj, &block)
      check!(obj, :read)
      block.call(obj)
    end

    def write(obj, &block)
      check!(obj, :write)
      obj.unlock_garrison_lock if respond_to?(:unlock_garrison_lock)
      block.call(obj)
    end

    private

    def check!(obj, doing)
      keeper_class = "#{obj.class.name}Keeper"
      method_name = "can_#{doing}?"

      raise Forbidden unless eval(keeper_class).new.send(method_name)
    end
  end
end