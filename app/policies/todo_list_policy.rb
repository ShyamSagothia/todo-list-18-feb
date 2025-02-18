class TodoListPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user.admin? || record.user_id == user.id

    # user.id == record.user_id  # Only owner can see their TodoList
  end

  def create?
    user.admin? || user.present?  # Only logged-in users can create
  end

  def update?
     user.admin? || record.user_id == user.id # Only owner can update
  end

  def destroy?
    user.admin? || record.user_id == user.id  # Only owner can delete
  end

  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end
end
