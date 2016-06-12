module Garrison
  module LockingActiveRecord
    def self.included(klass)
      klass.class_eval do
        after_initialize :lock_garrison_lock
        before_validation :check_garrison_lock_unlock
        after_save :lock_garrison_lock_force
      end
    end

    def lock_garrison_lock
      @_garrison_lock = true if Garrison.target?(self) && @_garrison_lock.nil?
    end

    def lock_garrison_lock_force
      @_garrison_lock = nil
      lock_garrison_lock
    end

    def garrison_locked?
      !!@_garrison_lock
    end

    def _garrison_lock=(val)
      @_garrison_lock = val
    end

    def check_garrison_lock_unlock
      raise Garrison::Locked if @_garrison_lock
    end

    def unlock_garrison_lock
      @_garrison_lock = false
    end
  end
end

