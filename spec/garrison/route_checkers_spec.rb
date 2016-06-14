require 'rails_helper'

RSpec.describe "RouteCheckers", type: :request do
  describe do
    it do
      post 'any'
      expect(response).to have_http_status(403)
    end

    it do
      post 'other'
      expect(response).to have_http_status(404)
    end

    it do
      get '/a'
      expect(response).to have_http_status(200)
    end

    it do
      get '/nested/a'
      expect(response).to have_http_status(200)
    end

    it do
      patch '/nested/a'
      expect(response).to have_http_status(404)
    end

    it do
      get '/nested/b'
      expect(response).to have_http_status(404)
    end

    it do
      patch '/nested/b'
      expect(response).to have_http_status(200)
    end
  end
end

class ConstraintCurrentUser
  def self.user
    @user ||= User.create!(name: 'constraint')
  end
end

class ForbiddenRouteChecker < Garrison::RouteCheckerAbstract
  def block_create?
    true
  end

  def block_create_other?
    false
  end
end

class DirectRouteChecker < Garrison::RouteCheckerAbstract
  def can_index?
    user.name == 'constraint'
  end
end

class NestedRouteChecker < Garrison::RouteCheckerAbstract
  def can_index?
    user.name == 'constraint'
  end

  def can_update?
    user.name == 'constraint'
  end
end

class NestedRouteChecker < Garrison::RouteCheckerAbstract
  def can_index?
    true
  end

  def can_update?
    false
  end
end

class NestedNestedRouteChecker < Garrison::RouteCheckerAbstract
  def can_index?
    false
  end

  def can_update?
    true
  end
end