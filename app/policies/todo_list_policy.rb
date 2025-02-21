class TodoListPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user.admin? || user_is_owner? || user_is_collaborator?
  end

  def create?
    user.present?
  end

  def update?
    user.admin? || user_is_owner?
  end

  def destroy?
    user.admin? || user_is_owner?
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        # Owner or collaborator can see the TodoList
        # scope.where(user: user).or(scope.joins(:collaborators).where(collaborations: { user_id: user.id }))
        scope
          .left_joins(:collaborators)
          .where('todo_lists.user_id = ? OR collaborations.user_id = ?', user.id, user.id)
          .distinct

      end
    end
  end

  private

  def user_is_owner?
    record.user_id == user.id
  end

  def user_is_collaborator?
    record.collaborators.exists?(id: user.id)
  end
end
