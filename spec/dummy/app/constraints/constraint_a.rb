class ConstraintA < Garrison::ConstraintAbstract
  def user
    ConstraintCurrentUser.user
  end
end