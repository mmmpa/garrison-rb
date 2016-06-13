module Garrison
  class Keeper
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def write(obj, &block)
      method_missing('write', obj, writable: true, &block)
    end

    def call(obj, doing, *args, writable: true, &block)
      make(obj, doing, *args, writable: writable, &block)
    end

    def make(obj, doing, *args, writable: true, &block)
      check!(obj, doing)
      unlock(obj) if writable
      ObjectProxy.new(obj).send(doing, *args, &block)
    ensure
      lock(obj) if writable
    end

    def method_missing(name, obj, writable: false, &block)
      process(name, obj, writable: writable, &block)
    end

    private

    def check!(obj, doing)
      checker = checker_class_for(obj).new(user, obj)

      raise Forbidden unless checker.send(checker_method_for(doing))
    end

    def checker_class_for(obj)
      name = "#{obj.class.name}Checker"
      eval(name.gsub('::', ''))
    end

    def checker_method_for(doing)
      "can_#{doing}?"
    end

    def process(name, obj, writable: false, &block)
      check!(obj, name)
      unlock(obj) if writable
      block.call(obj) if block_given?
    ensure
      lock(obj) if writable
    end

    def lock(obj)
      obj.garrison.lock! if obj.respond_to? :garrison
    end

    def unlock(obj)
      obj.garrison.unlock! if obj.respond_to? :garrison
    end
  end
end
