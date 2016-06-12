module Garrison
  class Injectee
    def lock_initial
      lock if @locked.nil?
    end

    def lock
      @locked = true
    end

    def unlock
      @locked = false
    end

    def locked?
      !!@locked
    end
  end
end