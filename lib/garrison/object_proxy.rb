#
# メソッドを待ち受け、
# - initialize時に与えられた@checkブロック内で
# - initialize時に与えられた@objオブジェクトのscopeで
# 実行する
#
# メソッドの返り値が変更されないように、
# @checkブロックはyieldの結果をそのまま返す動作をすること
#

module Garrison
  class ObjectProxy
    def initialize(obj, &block)
      @obj = obj
      @check = block
    end

    def method_missing(name, *args, &block)
      @check.call(name) do
        @obj.send(name, *args, &block)
      end
    end
  end
end