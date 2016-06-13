module Garrison
  class Keeper
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def write(obj, &block)
      method_missing('write', obj, writable: true, &block)
    end

    def call(obj, writable: true)
      chain(obj, writable: writable)
    end

    def chain(obj, writable: true)
      ObjectProxy.new(obj) do |doing, &block|
        begin
          check!(obj, doing)
          unlock(obj) if writable
          block.call
        ensure
          lock(obj) if writable
        end
      end
    end

    def method_missing(name, obj, writable: false, &block)
      process(name, obj, writable: writable, &block)
    end

    private

    def check!(obj, doing)
      checker = checker_for(obj).new(user, obj)

      raise Forbidden unless checker.send(checker_method_for(doing))
    end

    def checker_for(obj)
      # インスタンス
      "#{obj.class.name}Checker".gsub('::', '').constantize
    rescue
      # クラス
      "#{obj.name}ClassChecker".gsub('::', '').constantize
    end

    def checker_method_for(doing)
      "can_#{doing.to_s.gsub('!', '')}?"
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
