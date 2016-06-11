module Garrison
  class << self
    def lock!(*models)
      enchant_lock(*models)
    end

    private

    def enchant_lock(*models)
      ActiveRecord::Base.class_eval do
        after_initialize :lock_garrison_lock
        before_validation :check_garrison_lock_unlock

        def lock_garrison_lock
          @garrison_lock = true if !models || models.include?(self.class)
        end

        def check_garrison_lock_unlock
          raise ::Garrison::Locked if @garrison_lock
        end

        def unlock_garrison_lock
          @garrison_lock = false
        end
      end
    end
  end

  class Locked < StandardError

  end

  class RequireImplement < StandardError

  end

  class Forbidden < StandardError

  end
end
