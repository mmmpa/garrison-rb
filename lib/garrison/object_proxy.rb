module Garrison
  class ObjectProxy
    def initialize(obj, &block)
      @obj = obj
      @around = block
    end

    def method_missing(name, *args, &block)
      @around.call(name) do
        @obj.send(name, *args, &block)
      end
    end
  end
end