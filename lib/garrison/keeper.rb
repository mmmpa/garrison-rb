module Garrison
  class Keeper
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def write(obj, &block)
      process('write', obj, writable: true, &block)
    end

    def call(obj, writable: true)
      ObjectProxy.new(obj) do |doing, &block|
        process(doing, obj, writable: writable, &block)
      end
    end

    private

    def check!(obj, doing)
      CheckerProxy.new(@user, obj, doing).check!
    end

    def method_missing(name, obj, writable: false, &block)
      process(name, obj, writable: writable, &block)
    end

    def process(doing, obj, writable: false, &block)
      check!(obj, doing)
      unlock(obj) if writable
      block.call(self) if block_given?
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
