class TodoPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user_is_owner? || user_is_collaborator?
  end

  def create?
    user_is_owner? || user_is_collaborator?
  end

  def update?
    user_is_owner? || user_is_collaborator?
  end

  def destroy?
    user_is_owner?
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope
          .joins(todo_list: :collaborators)
          .where('todo_lists.user_id = ? OR collaborations.user_id = ?', user.id, user.id)
          .distinct

        # scope.joins(:todo_list).where(todo_lists: { user_id: user.id })
      end
    end
  end

  private

  def user_is_owner?
    record.todo_list.user_id == user.id
  end

  def user_is_collaborator?
    record.todo_list.collaborators.exists?(id: user.id)
  end
end
