module Garrison
  module LockingActiveRecord
    def self.included(klass)
      klass.instance_eval {
        after_initialize -> { garrison.lock_initial if Garrison.target?(self) }
        before_save -> { raise Garrison::Locked if garrison.locked? }
        after_save -> { garrison.lock if Garrison.target?(self) }
      } if klass.respond_to? :after_initialize
    end

    def garrison
      @garrison_injectee ||= Injectee.new
    end

    def garrison_locked=(val)
      !!val ? garrison.lock : garrison.unlock
    end
  end
end

