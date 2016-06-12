module Garrison
  class Keeper
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def read(obj, &block)
      check!(obj, :read)
      block.call(obj) if block_given?
    end

    def write(obj, &block)
      check!(obj, :write)
      obj.unlock_garrison_lock if obj.respond_to?(:unlock_garrison_lock)
      result = block.call(obj) if block_given?
      obj.lock_garrison_lock_force if obj.respond_to?(:lock_garrison_lock_force)
      result
    end

    def method_missing(name, obj, writable = false, &block)
      check!(obj, name)
      obj.unlock_garrison_lock if obj.respond_to?(:unlock_garrison_lock) && writable
      result = block.call(obj) if block_given?
      obj.lock_garrison_lock_force if obj.respond_to?(:lock_garrison_lock_force) && writable
      result
    end

    private

    def check!(obj, doing)
      keeper_class = "#{obj.class.name}Checker"
      method_name = "can_#{doing}?"

      raise Forbidden unless eval(keeper_class).new(user, obj).send(method_name)
    end
  end
end