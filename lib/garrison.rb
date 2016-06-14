require 'garrison/locking_active_record'
require 'garrison/checker_abstract'
require 'garrison/keeper'
require 'garrison/injectee'
require 'garrison/object_proxy'
require 'garrison/checker_proxy'
require 'garrison/constraint_abstract'

module Garrison
  class << self
    attr_reader :models

    def lock!(*models)
      @models = models
      enchant_lock
    end

    def target?(obj)
      !@models || @models.include?(obj.class)|| @models.include?(obj)
    end

    private

    def enchant_lock
      @enchanted ||= begin
        ActiveRecord::Base.include LockingActiveRecord
      end
    end
  end

  class Locked < StandardError
  end

  class Forbidden < StandardError
  end

  class ImplementRequired < StandardError

  end
end

