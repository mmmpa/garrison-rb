class GuardConstraint < Garrison::ConstraintAbstract
  def user
    ConstraintCurrentUser.user
  end

  def for_guard
    true
  end
end