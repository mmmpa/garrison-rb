module Garrison
  class CheckerAbstract
    attr_reader :user, :obj

    def initialize(user, obj)
      @user = user || AnonymousOne.new
      @obj = obj
    end

    def can_write?
      false
    end

    def method_missing(*)
      false
    end

    class AnonymousOne
      def method_missing(name, *)
        return false if !!name.match(/\?$/)
        return nil if !!name.match(/^to_/)
        AnonymousOne.new
      end
    end
  end
end