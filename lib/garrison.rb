require 'garrison/locking_active_record'
require 'garrison/keeper'
require 'garrison/checker_abstract'

module Garrison
  class << self
    attr_reader :models

    def lock!(*models)
      @models = models
      enchant_lock
    end

    def target?(obj)
      !models || models.include?(obj.class)|| models.include?(obj)
    end

    private

    def enchant_lock
      ActiveRecord::Base.include LockingActiveRecord
    end
  end

  class Locked < StandardError

  end

  class RequireImplement < StandardError

  end

  class Forbidden < StandardError

  end
end

