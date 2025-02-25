class TodoListPolicy
  attr_reader :user, :todo_list

  def initialize(user, todo_list)
    @user = user
    @todo_list = todo_list
  end

  # def index?
  #   # user_or_collab?
  #   Rails.logger.debug "Is user the owner? #{todo_list.user?}"
  #   Rails.logger.debug "Is user the collab.?#{todo_list.user.include?(user)}"
  #   todo_list.user? || todo_list.user.include?(user)
  # end

  

  def show?
    own? || collab?
  end

  def update?
    own? || collab?
  end

  # binding.pry

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
    # Rails.logger.debug "is user collab.?#{todo_list.users.include?(user)}"
    todo_list.collaborators_users.include?(user)
  end

  class Scope
    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      # scope.where(collaborator: {user_id: user.id}) || scope.where(user: user.id) # || will not work user or
      # scope.where(user: user.id).or(scope.joins(:collaborators).where(collaborators: {user_id: user.id})) # first join the table

      # binding.pry
    
      scope.left_joins(:collaborators)
        .where(collaborators: {user_id: user.id})
          .or(scope.where(user:user.id))

    end

    private

    attr_reader :user, :scope
  end
end

# def show?
#   Rails.logger.debug "Is user the owner? #{user == record.todo_list}"
#   Rails.logger.debug "Is user the collab. #{user == @record.collaborators.todo_list}"
#   @record.todo_list? || @record.collaborators.todo_list?
# end

# private

# def own_or_collab?
#   # Rails.logger.debug "Is user a collaborator? #{todo_list.collaborators.include?(@record.user)}"
#   Rails.logger.debug "Is user the owner? #{user == todo_list.user}"
#   user == todo_list.user || todo_list.collaborators.user
# end
