module Garrison
  class Keeper
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def write(obj, writable: true, &block)
      process(:write, obj, writable, &block)
    end

    def method_missing(name, obj, writable: false, &block)
      process(name, obj, writable, &block)
    end

    private

    def check!(obj, doing)
      keeper_class = "#{obj.class.name}Checker"
      method_name = "can_#{doing}?"

      raise Forbidden unless eval(keeper_class.gsub('::', '')).new(user, obj).send(method_name)
    end

    def process(name, obj, writable = false, &block)
      check!(obj, name)
      obj.garrison.unlock if writable && obj.respond_to?(:garrison)
      result = block.call(obj) if block_given?
      obj.garrison.lock if writable && obj.respond_to?(:garrison)
      result
    end
  end
end