class TodoListPolicy
  attr_reader :user, :todo_list

  def initialize(user, todo_list)
    @user = user
    @todo_list = todo_list
  end

  def show?
    own? || collab?
  end

  def update?
    own? || collab?
  end

  def create?
    Rails.logger.debug "Is user present? #{user.present?}"
    user.present?
  end

  def destroy?
    own?
  end

  private

  def own?
    user == todo_list.user
  end

  def collab?
    todo_list.collaborators_users.include?(user)
  end

  class Scope
    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      scope.left_joins(:collaborators)
        .where(collaborators: { user_id: user.id })
          .or(scope.where(user: user.id)).distinct
    end

    private

    attr_reader :user, :scope
  end
end
