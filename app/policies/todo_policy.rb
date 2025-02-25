class TodoPolicy
  attr_reader :user, :todo

  def initialize(user, todo)
    @user = user
    @todo = todo
  end

  def show?
    own? || collab?
  end

  def update?
    own? || collab?
  end

  def create?
    own?
  end

  def destroy?
    own?
  end

  private
  
  def own?

    user == todo.todo_list.user
  end

  def collab?
    todo.todo_list.collaborators_users.include?(user)
  end

  class Scope
    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve

      scope.left_joins(todo_list: :collaborators)
        .where(todo_list: { user_id: user.id })
          .or(scope.where(collaborators: { user_id: user.id }))
            .distinct
    end

    private

    attr_reader :user, :scope
  end
end
