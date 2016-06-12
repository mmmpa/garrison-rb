module Garrison
  class Injectee
    def lock_initial
      lock if @locked.nil?
    end

    def lock
      @locked = true unless !!@hard
    end

    def unlock
      @locked = false unless !!@hard
    end

    def lock!
      unlock_hard
      lock
    end

    def unlock!
      unlock
      lock_hard
    end

    def locked?
      !!@locked
    end

    private

    def lock_hard
      @hard = true
    end

    def unlock_hard
      @hard = false
    end
  end
end