module Garrison
  class ObjectProxy
    def initialize(obj)
      @obj = obj
    end

    def method_missing(name, *args, &block)
      @obj.send(name, *args, &block)
    end
  end
end