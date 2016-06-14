class ForbiddenController < ApplicationController
  def index
  end

  def create
    head :forbidden
  end
end
