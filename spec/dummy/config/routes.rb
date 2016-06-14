Dummy::Application.routes.draw do
  scope constraints: GuardConstraint.new do
    post 'any' => 'forbidden#create'
    post 'other' => 'forbidden#create_other'
    get 'a' => 'direct#index'
  end

  scope constraints: ConstraintA.new do
    get 'a' => 'direct#index'
    patch 'a' => 'direct#update'

    scope :nested do
      get 'a' => 'nested#index'
      patch 'a' => 'nested#update'
      get 'b' => 'nested/nested#index'
      patch 'b' => 'nested/nested#update'
    end
  end

  get '*path' => ->(_) { [404, {"Content-Type" => 'text/plain'}, ['']] }
  post '*path' => ->(_) { [404, {"Content-Type" => 'text/plain'}, ['']] }
  patch '*path' => ->(_) { [404, {"Content-Type" => 'text/plain'}, ['']] }
end
