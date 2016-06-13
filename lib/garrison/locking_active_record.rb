module Garrison
  module LockingActiveRecord
    def self.included(klass)
      return unless klass.respond_to? :after_initialize

      klass.class_eval do
        after_initialize -> { garrison.lock_initial if Garrison.target?(self) }
        before_save -> { raise Garrison::Locked if garrison.locked? }
        after_save -> { garrison.lock if Garrison.target?(self) }
      end
    end

    def garrison
      @garrison_injectee ||= Injectee.new
    end

    def garrison_locked=(val)
      !!val ? garrison.lock : garrison.unlock
    end
  end
end

